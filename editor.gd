extends Node2D

func save():
	var rawData = ""
	for node in $grid.get_children():
		if node.isLiving:
			rawData += "("+str(node.position.x)+","+str(node.position.y)+")"+str(node.color)+";"
	OS.clipboard = rawData

func _input(event):
	if event.is_action("rclick"):
		save()
	if event.is_action("mmiddle"):
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://title.tscn")
