extends Control



func _ready():
	if !Global.preCentered:
		OS.center_window()
		OS.window_maximized = true
		Global.preCentered = true
	for c in $settings/list.get_children():
		if c is SpinBox or c is HSlider:
			c.value = Global.settings[c.get_meta("setting")]
	updateUI()

func updateUI():
	var d = Directory.new()
	if d.file_exists("user://session"):
		$load.show()
		$loadCode.rect_position = Vector2(237, 432)
		$loadCode.rect_size = Vector2(122, 23)
		#$seed.rect_position = Vector2(237, 288)
		#$seed.rect_size = Vector2(423, 24)
	else:
		$load.hide()
		$loadCode.rect_position = Vector2(366, 463)
		$loadCode.rect_size = Vector2(295, 23)

func text_in(_text):
	start_game()

func start_game():
	Score.points = 0
	Score.tilesDestroyed = 0
	Score.tilesLost = 0
	Score.tilesPlaced = 0
	var gameSeed = $seed.text.hash()*Global.settings.smulti
	if gameSeed != "".hash():
		seed(gameSeed)
		Global.currentSeed = gameSeed
		Global.userSeed = $seed.text
	else:
		Global.currentSeed = -1
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://main.tscn")


func save_toggle(button_pressed, toggle):
	Global.settings[toggle] = button_pressed
	Global.save()


func spin_change(value, item):
	Global.settings[item] = value
	Global.save()


func exit_game():
	get_tree().quit()


func load_last_session():
	var file = File.new()
	file.open_encrypted_with_pass("user://session", File.READ, "sessionData")
	var content = file.get_as_text()
	file.close()
	var data = str2var(content)
	if data["seed"] != -1:
		seed(data["seed"])
	Score.points = data.score
	Score.tilesLost = data.lost
	Score.tilesDestroyed = data.destroyed
	Score.tilesPlaced = data.placed
	Global.loadData = {
		"hexes":data.hexes,
		"ccol":data.currentColor,
		"ncol":data.nextColor,
		"storage":data.storage
	}
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://main.tscn")


func go_to_editor():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://editor.tscn")


func delete_session():
	var d = Directory.new()
	d.remove("user://session")
	updateUI()

func submit_world_code(_input):
	load_world()

func load_world():
	Global.worldData = $worldCode.text
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://main.tscn")
