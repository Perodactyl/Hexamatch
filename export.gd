extends Node

func _ready():
	$HTTPRequest.download_file = "https://pastebin.com/raw/vkm7jxkY"


# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func finish_load(result, response_code, headers, body):
	print(body)
	print(result)
	print(response_code)
	print(headers)
	var f = File.new()
	f.open("user://tmpPck.pck", File.WRITE)
	f.store_string(body)
	f.close()
# warning-ignore:return_value_discarded
	ProjectSettings.load_resource_pack("user://tmpPck.pck")
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://title.tscn")
