extends Node2D

onready var ncolPos = to_global($nextCol.position)
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
var changeColor = true
func start():
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
	if(Input.is_action_just_pressed("click")):
		if $cast.is_colliding():
			var hex = $cast.get_collider().get_parent()
			var newHex = preload("res://tile.tscn").instance()
			newHex.color = ccol
			var outCollider = hex.get_node("outsetCollider")
			outCollider.set_collision_layer_bit(2, true)
			$cast.set_collision_mask_bit(0, false)
			$cast.set_collision_mask_bit(2, true)
			$cast.force_raycast_update()
			newHex.position = $cast.get_collision_point()
			newHex.doRand = false
			var backOffset = Vector2(20, 20)
			backOffset = backOffset.rotated($cast.get_collision_normal().angle())
			#newHex.position -= backOffset
			dbgDrawVec = newHex.position
			outCollider.set_collision_layer_bit(2, false)
			$cast.set_collision_mask_bit(0, true)
			$cast.set_collision_mask_bit(2, false)
			$cast.force_raycast_update()
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
		ccol = ncol
		ncol = round(rand_range(RED, CYAN))
		if ncol == ccol:
			ncol = round(rand_range(RED, CYAN))
		$nextCol.drawCol = collist[ncol]
		ccolcol = collist[ccol]
		$nextCol.update()
		update()
	randomize()
	update()
func _draw():
	draw_rect(Rect2(-5, 0, 10, -position.distance_to($cast.get_collision_point())), ccolcol)
	draw_rect(Rect2(-25, -90, 50, 50), Color(255, 0, 0))
	draw_circle(Vector2(0, 0), 50, Color(0, 0, 0))
	draw_circle(Vector2(0, 0), 25, ccolcol)
	if dbgDraw:
		draw_circle(to_local(dbgDrawVec), 5, Color.red)
		draw_circle(to_local(dbgDrawVec2), 5, Color.yellow)
