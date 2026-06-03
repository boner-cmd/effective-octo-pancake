extends Node3D

@export var uid_string : String 

var id: int = ResourceUID.text_to_id(uid_string)
	
func _ready() -> void:
	if ResourceUID.has_id(id):
		var full_path: String = ResourceUID.get_id_path(id)
		var file_name: String = full_path.get_file()
		print("Resource Name: ", file_name)
	else:
		print("UID not found in cache: ", uid_string)
