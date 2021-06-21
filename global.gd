extends Node

enum {
	RED,
	GREEN,
	BLUE,
	YELLOW,
	PINK,
	CYAN
}
var collist = [
	Color.red,
	Color.green,
	Color.blue,
	Color.yellow,
	Color.pink,
	Color.cyan
]

var settings = {
	"groupreq":3,
	"smulti":1,
	"volume":100
}
var preCentered = false
var currentSeed = null
var userSeed = ""
var loadData = null
var worldData = null

func save():
	var file = File.new()
	file.open("user://settings.json", File.WRITE)
	file.store_string(to_json(settings))
	file.close()

func loadSettings():
	var dir = Directory.new()
	if !dir.file_exists("user://settings.json"):
		return false
	var file = File.new()
	file.open("user://settings.json", File.READ)
	var data = str2var(file.get_as_text())
	for key in settings.keys():
		if not data.has(key):
			return false
	settings = data
	file.close()
	return true

func _ready():
	if !loadSettings():
		save()

func _input(event):
	if event.is_action_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
