extends Area2D

var doneFrames = 0
func _process(_delta):
	if doneFrames == 0:
		for hex in get_overlapping_bodies():
			hex.get_parent().root = true
	else:
		doneFrames += 1
