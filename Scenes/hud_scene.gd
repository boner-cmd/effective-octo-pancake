extends CanvasLayer

# @onready var interaction_prompt : MarginContainer = $Control/InteractionMargin
# @onready var interaction_label : Label = $Control/InteractionMargin/LabelMargin/InteractionLabel
@onready var stickerbook : NinePatchRect = $StickerbookBackground
@onready var pause_background : NinePatchRect = $PauseBackground
@onready var complete_stamp : TextureRect = $StickerbookBackground/CompleteStamp

# overall HUD visibility. Should rarely be totally hidden.
func show_hud() -> void:
	visible = true
func hide_hud() -> void:
	visible = false

# interaction prompt handlers, can be called directly from outside
#func show_interaction_prompt() -> void:
	#interaction_prompt.visible = true
#func hide_interaction_prompt() -> void:
	#interaction_prompt.visible = false
#func set_interaction_label(text : String) -> void:
	#interaction_label.text = text

# separated out in case more needs to go in _ready
func set_initial_visibility() -> void:
	visible = true
#	interaction_prompt.visible = false
	stickerbook.visible = false
	pause_background.visible = false
	complete_stamp.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_pause"):
		get_tree().paused = true

# set initial visibility states
func _ready() -> void:
	set_initial_visibility()

func _on_quit_button_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

func _on_continue_button_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pause_background.visible = false
