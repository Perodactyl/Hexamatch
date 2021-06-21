extends Node2D

var hexAmt = Vector2(20, 3)
var increment = Vector2(88, 75)
var offset = 44
var hex = preload("res://tile.tscn")

func _ready():
	if !Global.loadData && !Global.worldData:
		for x in range(hexAmt.x):
			for y in range(hexAmt.y):
				var p = hex.instance()
				p.position = Vector2((x*increment.x)+(offset*(y&1)), y*increment.y)
				add_child(p, true)
	elif Global.loadData && !Global.worldData:
		$player.changeColor = false
		$player.ccol = Global.loadData.ccol
		$player.ncol = Global.loadData.ncol
		for hexData in Global.loadData.hexes:
			var newHex = hex.instance()
			newHex.color = hexData.color
			newHex.position.x = hexData.position[0]
			newHex.position.y = hexData.position[1]
			newHex.doRand = false
			add_child(newHex, true)
		var d = Directory.new()
		if d.file_exists("user://session"):
			d.remove("user://session")
	else:
		var worldCodeReg = RegEx.new()
		worldCodeReg.compile("\\(([0-9]+),\\s*([0-9]+)\\)([0-9]+);")
		var worldData = Global.worldData
		var regRes = worldCodeReg.search_all(worldData)
		for el in regRes:
			var newHex = hex.instance()
			print(el.strings)
			newHex.position.x = int(el.strings[1])
			newHex.position.y = int(el.strings[2])
			newHex.color = int(el.strings[3])
			newHex.doRand = false
			add_child(newHex, true)
		Global.worldData = null
	Global.loadData = null
	$player.start()
	$sfx.volume_db = Global.settings.volume-100
func _process(delta):
	if delta > 0.15 and !$lag.visible:
		$lag.show()
	elif $lag.visible:
		$lag.hide()
	var hexesExist = false
	for child in get_children():
		if child.has_method("checkTiles"):
			hexesExist = true
			break
	if !hexesExist and !$win.visible:
		var winText = "You win!\nscore:"
		winText += str(Score.points)
		$win.text = winText
		$win.show()
		$sfx.stream = preload("res://beatGame.wav")
		$sfx.play()
		pause_mode = PAUSE_MODE_PROCESS
		$player.pause_mode = PAUSE_MODE_STOP
		get_tree().paused = true


func reset_game():
	get_tree().paused = false
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://title.tscn")
