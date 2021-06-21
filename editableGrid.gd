extends Node2D

var increment = Vector2(88, 75)
var offset = 44
var maxX = 25
var maxY = 25
var negativeStart = 10
var hexScene = preload("res://editorHex.tscn")

func _ready():
	for x in range(-negativeStart, maxX-negativeStart):
		for y in range(-negativeStart, maxY-negativeStart):
			var p = hexScene.instance()
			p.position = Vector2((x*increment.x)+(offset*(y&1)), y*increment.y)
			add_child(p, true)
