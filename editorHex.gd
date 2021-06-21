extends Node2D

var isLiving = false
var mouseCapture = false
var color = Global.RED

func modLiving(value):
	isLiving = value
	update()

func snapToGrid(grid):
	var closestNode = Vector2(1000000, 1000000)
	for pos in grid.get_children():
		var loc = pos.position
		if position.distance_to(loc) < position.distance_to(closestNode):
			closestNode = loc
	position = closestNode

func _draw():
	if !isLiving:
		draw_circle(Vector2.ZERO, 5, Color.white)
		$display.hide()
	else:
		$display.show()


func toggle_living():
	modLiving(!isLiving)

# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_just_released("scrollUp") and mouseCapture:
		color = color + 1
		color = color % (Global.CYAN+1)
	if Input.is_action_just_released("scrollDown") and mouseCapture:
		color = color + 1
		color = color % (Global.CYAN+1)
	if Input.is_action_just_released("click") and mouseCapture:
		toggle_living()
	$display.modulate = Global.collist[color]

func toggle_mouse(state):
	mouseCapture = state
