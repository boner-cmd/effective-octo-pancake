extends Node3D

enum {IDLE, WALK, JUMP, GET, GIVE, TALK, VICTORY}

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


#control anim state for player on interact
func _on_area_3d__give() -> void:
	$"PlayerCharacter".current_anim = GIVE
	print("give")

func _on_area_3d__listen() -> void:
	$"PlayerCharacter".current_anim = TALK
	print("listen")

func _on_area_3d__receive() -> void:
	$"PlayerCharacter".current_anim = GET
	print("receive")

func _on_area_3d__complete() -> void:
	$"PlayerCharacter".current_anim = IDLE
	print("idle")
