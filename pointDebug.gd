extends Position2D

var debugDraw = false setget setDraw
var debugColor = Color.white setget setColor

func setDraw(value):
	debugDraw = value
	update()

func setColor(value):
	debugColor = value
	update()

func _draw():
	if debugDraw:
		draw_circle(Vector2(0, 0), 5, debugColor)
