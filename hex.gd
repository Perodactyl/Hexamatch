extends Node2D

export(bool)var root = false
export(bool)var touchingroot = false
var touchingCasts = 0
var deadFrames = 0
var checkFrames = 0
var mouseOver = false
var color = RED
var doRand = true
enum {
	RED,
	GREEN,
	BLUE,
	YELLOW,
	PINK,
	CYAN
}
var collist = [
	Color.red,
	Color.green,
	Color.blue,
	Color.yellow,
	Color.pink,
	Color.cyan
]
const printTerm = false


func _ready():
	$collider.hide()
	$drawShape.polygon = $collider/shape.polygon
	for c in $casting.get_children():
		c.add_exception(self)
		c.add_exception($collider)
		c.force_raycast_update()
		c.visible = c.is_colliding()
		if c.is_colliding():
			touchingCasts += 1
		if root:
			c.color = Color.orange
			c.update()
	if doRand:
		color = round(rand_range(RED, CYAN))
	$drawShape.modulate = collist[color]
	snapToGrid(get_parent().get_node("grid"))
	$sfx.volume_db = Global.settings.volume-100

var killBelow = false

func _physics_process(_delta):
	touchingCasts = 0
	if(checkFrames >= 3):
		checkFrames = 0
		recheck()
	for c in $casting.get_children():
		c.visible = c.is_colliding()
		var isHex = c.is_colliding() and c.get_collider().get_parent().has_method("checkTiles")
		if(c.is_colliding() && isHex):
			touchingCasts += 1
#		if c.is_colliding() && (c.get_collider().get_parent().touchingroot || c.get_collider().get_parent().root):
#			foundRoot = true
		if (root || touchingroot) && c.is_colliding() && isHex:
			c.get_collider().get_parent().touchingroot = true
		if c.is_colliding() and c.get_collider().get_parent().position == position && isHex:
			c.get_collider().get_parent().terminate("Target was at the same position", false)
	if killBelow:
		if $casting/RayCast2D.is_colliding():
			var collider = $casting/RayCast2D
			if collider.get_parent() and collider.get_parent().has_method("checkTiles"):
				collider.get_parent().killFalling()
		if $casting/RayCast2D6.is_colliding():
			var collider = $casting/RayCast2D6
			if collider.get_parent() and collider.get_parent().has_method("checkTiles"):
				collider.get_parent().killFalling()
	checkFrames += 1
	if(touchingroot):
		deadFrames = 0
	elif not root:
		deadFrames += 1
	if !(position.x in range(0, 1024)) || !(position.y in range(0, 600)):
		terminate("Freeing "+name+" for being out of bounds.", false)
	if deadFrames >= 60 && !$kill.is_active():
		killFalling()

func killFalling():
	$kill.interpolate_property(self, "position", position, Vector2(position.x, position.y+600), 2)
	killBelow = true
	killAnim()
	$casting/RayCast2D.enabled = true
	$casting/RayCast2D6.enabled = true
	Score.add(500)

func recheck():
	touchingroot = false


func onMouseOver():
	mouseOver = true


func onMouseOut():
	mouseOver = false

func checkTiles(exclude):
	var tEx = exclude
	var canFree = false
	var otherTiles = 0
	tEx.append(self)
#	for c in $casting.get_children():
#		if c.is_colliding():
#			if c.get_collider().get_parent() in exclude:
#				c.modulate = Color.red
#			elif c.get_collider().get_parent().color == color:
#				c.modulate = Color.red
#				c.get_collider().get_parent().checkTiles(tEx)
#				c.get_collider().get_parent().terminate(null)
#				otherTiles += 1
#				multiplyAmt += 1
	var foundItems = recursiveGetAmt([])
	otherTiles = len(foundItems)
	print(otherTiles)
	if Global.settings.groupreq <= otherTiles:
		canFree = true
	if canFree:
		for hex in foundItems:
			hex.killResize()
		killResize()
		Score.accumulate(1000)
	for _m in range(otherTiles):
		Score.multiply(4)

func killResize():
	if !$kill.is_active():
		$kill.interpolate_property(self, "scale", scale, Vector2.ZERO, 1)
		$kill.interpolate_property(self, "rotation_degrees", 0, 359, 1)
		killAnim()
		$sfx.stream = preload("res://breakHex.wav")
		$sfx.play()

func recursiveGetAmt(found:Array):
	for cast in $casting.get_children():
		if cast.is_colliding():
			var hex = cast.get_collider().get_parent()
			if hex.has_method("checkTiles") && hex.color == color && !(hex in found):
				found.append(hex)
				found = found + hex.recursiveGetAmt(found.duplicate())
	return found

func killAnim():
	for cast in $casting.get_children():
		cast.enabled = false
	if $freeTimer.is_connected("timeout", self, "freeNow"):
		$freeTimer.disconnect("timeout", self, "freeNow")
	$collider.collision_layer = 0
	if !$kill.is_connected("tween_all_completed", self, "end"):
# warning-ignore:return_value_discarded
		$kill.connect("tween_all_completed", self, "end")
	$kill.start()

func snapToGrid(grid):
	var closestNode = Vector2(1000000, 1000000)
	for pos in grid.get_children():
		var loc = pos.position
		if position.distance_to(loc) < position.distance_to(closestNode):
			closestNode = loc
	position = closestNode

func end():
	Score.tilesDestroyed += 1
	queue_free()

func freeNow():
	queue_free()

func terminate(reason, addTerm=true):
	if !$kill.is_active() && $freeTimer.is_stopped():
		if addTerm:
			Score.tilesDestroyed += 1
		if reason and printTerm:
			print(reason)
		$freeTimer.start()

func _draw():
	if $casting.visible:
		draw_circle(Vector2.ZERO, 5, Color.white)


func baseLoad_done():
	update()
