extends Panel

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_paused()

func save_session():
	var sessionData = {
		"score":Score.points,
		"lost":Score.tilesLost,
		"destroyed":Score.tilesDestroyed,
		"placed":Score.tilesPlaced,
		"currentColor":get_parent().get_node("player").ccol,
		"nextColor":get_parent().get_node("player").ncol,
		"seed":Global.currentSeed,
		"storage":get_parent().get_node("player").storage,
		"hexes":[]
	}
	for node in get_parent().get_children():
		if node.has_method("checkTiles"):
			sessionData.hexes.append({
				"position":[node.position.x, node.position.y],
				"color":node.color
			})
	var file = File.new()
	file.open_encrypted_with_pass("user://session", File.WRITE, "sessionData")
	file.store_string(to_json(sessionData))
	file.close()
	get_tree().paused = false
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://title.tscn")

func toggle_paused():
	visible = !visible
	get_tree().paused = !get_tree().paused


func return_to_title():
	get_tree().paused = false
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://title.tscn")

func quit_game(real):
	if real:
		get_tree().quit()
	else:
		$list.hide()
		$confirm.show()


func cancel_confirm():
	$list.show()
	$confirm.hide()
