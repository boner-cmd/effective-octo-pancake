# TODO put the interaction prompt handling in this script
extends CanvasLayer

@onready var stickerbook : NinePatchRect = $StickerbookBackground
@onready var pause_background : NinePatchRect = $PauseBackground
@onready var complete_stamp : TextureRect = $StickerbookBackground/CompleteStamp

# separated out in case more needs to go in _ready
func set_initial_visibility() -> void:
	visible = true
	stickerbook.visible = false
	pause_background.visible = false
	complete_stamp.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_pause"):
		get_tree().paused = !get_tree().paused
		# using set_mouse_mode resolves a warning about using enums like ints
		Input.set_mouse_mode(Input.mouse_mode ^ Input.MOUSE_MODE_VISIBLE ^ Input.MOUSE_MODE_CAPTURED)
		pause_background.visible = !pause_background.visible

# set initial visibility states
func _ready() -> void:
	set_initial_visibility()

func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pause_background.visible = false
