extends Node2D


var increment = Vector2(88, 75)
var offset = 44
var maxX = 100
var maxY = 100
var doDebug = false
var negativeStart = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(-negativeStart, maxX-negativeStart):
		for y in range(-negativeStart, maxY-negativeStart):
			var p = Position2D.new()
			p.position = Vector2((x*increment.x)+(offset*(y&1)), y*increment.y)
			p.set_script(preload("pointDebug.gd"))
			p.debugDraw = doDebug
			add_child(p)
