extends Node2D

onready var ncolPos = to_global($nextCol.position)
onready var storPos = to_global($storedCol.position)
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
export(int, "Red", "Green", "Blue", "Yellow", "Pink", "Cyan")var startColor = RED
var ccol = RED
var ccolcol = collist[ccol]
var ncol
var dbgDraw = false
var dbgDrawVec = Vector2.ZERO
var dbgDrawVec2 = Vector2.ZERO
var dbgLine = Vector2.ZERO
var changeColor = true
var storage = -1
func start():
	randomize()
	if changeColor:
		ccol = startColor
		ncol = RED
	$nextCol.drawCol = collist[ncol]
	$nextCol.update()
	ccolcol = collist[ccol]
	$sfx.volume_db = Global.settings.volume-100
func _process(_delta):
	look_at(get_global_mouse_position())
	rotation_degrees += 90
	$nextCol.position = to_local(ncolPos)
	$storedCol.position = to_local(storPos)
	var releaseStore = Input.is_action_just_pressed("mmiddle") && (storage != -1)
	$storedCol.visible = (storage != -1)
	if $cast.is_colliding() and $cast.get_collider() == $"/root/scene/bounds":
		$cast2.global_position = $cast.get_collision_point()
		var vec1 = $cast.get_collision_point() - $cast.global_position
		var reflectVec = -vec1.reflect($cast.get_collision_normal())
		$cast2.global_rotation = reflectVec.angle()+PI/2
		$cast2.show()
		$cast2.col = ccolcol
		$cast2.update()
	else:
		$cast2.hide()
	if(Input.is_action_just_pressed("click") || releaseStore):
		print(releaseStore)
		print(storage)
		var cast = $cast
		if $cast.is_colliding() and $cast.get_collider() == $"/root/scene/bounds":
				cast = $cast2
		cast.force_raycast_update()
		if cast.is_colliding() && cast.get_collider().get_parent().has_method("checkTiles"):
			print(cast.name)
			var hex = cast.get_collider().get_parent()
			var newHex = preload("res://tile.tscn").instance()
			newHex.color = storage if releaseStore else ccol
			var outCollider = hex.get_node("outsetCollider")
			outCollider.set_collision_layer_bit(2, true)
			cast.set_collision_mask_bit(0, false)
			cast.set_collision_mask_bit(2, true)
			cast.force_raycast_update()
			newHex.position = cast.get_collision_point()
			newHex.doRand = false
			var backOffset = Vector2(20, 20)
			backOffset = backOffset.rotated(cast.get_collision_normal().angle())
			#newHex.position -= backOffset
			dbgDrawVec = newHex.position
			outCollider.set_collision_layer_bit(2, false)
			cast.set_collision_mask_bit(0, true)
			cast.set_collision_mask_bit(2, false)
			cast.force_raycast_update()
			newHex.snapToGrid(get_parent().get_node("grid"))
			dbgDrawVec2 = newHex.position
			get_parent().add_child(newHex)
			newHex.checkTiles([])
			Score.tilesPlaced += 1
		else:
			Score.subtract(250*Global.settings.groupreq)
			Score.tilesLost += 1
			$sfx.stream = preload("res://loseHex.wav")
			$sfx.play()
		if !releaseStore:
			rollColor()
	if Input.is_action_just_pressed("mmiddle") && (storage == -1):
		storage = ccol
		$storedCol.drawCol = collist[storage]
		rollColor()
	if releaseStore:
			storage = -1
	update()
func _draw():
	draw_rect(Rect2(-5, 0, 10, -position.distance_to($cast.get_collision_point())), ccolcol)
	if $cast.is_colliding():
		draw_circle(to_local($cast.get_collision_point()), 5, ccolcol)
	else:
		draw_rect(Rect2(-5, 0, 10, -1000), ccolcol)
	draw_rect(Rect2(-25, -90, 50, 50), Color(255, 0, 0))
	draw_circle(Vector2(0, 0), 50, Color(0, 0, 0))
	draw_circle(Vector2(0, 0), 25, ccolcol)
	if dbgDraw:
		draw_circle(to_local(dbgDrawVec), 5, Color.red)
		draw_circle(to_local(dbgDrawVec2), 5, Color.yellow)
		draw_line($cast.get_collision_point(), dbgLine*10, Color.beige, 5)
func rollColor():
	ccol = ncol
	ncol = round(rand_range(RED, CYAN))
	if ncol == ccol:
		ncol = round(rand_range(RED, CYAN))
	$nextCol.drawCol = collist[ncol]
	ccolcol = collist[ccol]
	$nextCol.update()
