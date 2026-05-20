extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_map_ui_ui_closed() -> void:
	$"PlayerCharacter".movement_frozen = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_map_ui_ui_opened() -> void:
	$"PlayerCharacter".movement_frozen = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
