extends Node

func _ready():
	var d = Directory.new()
	if !d.file_exists("user://gdMs.pck"):
		return
	ProjectSettings.load_resource_pack("user://gdMs.pck")
	get_tree().idle(1)
	var n = Node.new()
	n.set_script(load("_gdmodExec.gd"))
	get_parent().call_deferred("add_child", n)
	print("adding _gdmodExec")
