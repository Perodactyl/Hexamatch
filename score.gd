extends Node

var points = 0
var frameCumulative = 0
var tilesPlaced = 0
var tilesDestroyed = 0
var tilesLost = 0
var totalAccum = 0

func add(amt):
	points += amt
func subtract(amt):
	points -= amt

func _process(delta):
	if get_tree().get_current_scene().name == "scene":
		process(delta)

func accumulate(amt):
	frameCumulative += amt

func multiply(amt):
	frameCumulative *= amt

func process(_delta):
	points += frameCumulative
	if frameCumulative > totalAccum:
		totalAccum = frameCumulative
	frameCumulative = 0
	$"/root/scene/points".text = str(points)
	$"/root/scene/tiles".text = str(tilesPlaced)
	$"/root/scene/AdvancedInfo/lost".text = str(tilesLost)
	$"/root/scene/AdvancedInfo/destroyed".text = str(tilesDestroyed)
