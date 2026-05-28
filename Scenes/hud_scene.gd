# TODO put the interaction prompt handling in this script
extends CanvasLayer

@onready var stickerbook : TextureRect = $StickerbookBackground
@onready var pause_menu : NinePatchRect = $PauseBackground
@onready var complete_stamp : TextureRect = $StickerbookBackground/CompleteStamp
@onready var transition_color: ColorRect = $ColorRect

# separated out in case more needs to go in _ready
func set_initial_visibility() -> void:
	visible = true
	stickerbook.visible = false
	pause_menu.visible = false
	complete_stamp.visible = false
	transition_color.visible = false
	
func toggle_pausing_and_mouse() -> void:
	get_tree().paused = !get_tree().paused
	# using set_mouse_mode resolves a warning about using enums like ints
	Input.set_mouse_mode(Input.mouse_mode ^ Input.MOUSE_MODE_VISIBLE ^ Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_pause"):
		if !stickerbook.visible: # relying on pause and mouse state already set if stickerbook visible
			toggle_pausing_and_mouse()
		stickerbook.visible = false
		pause_menu.visible = !pause_menu.visible
	if event.is_action_pressed("toggle_stickerbook"):
		if !pause_menu.visible: # don't allow showing the stickerbook while paused
			toggle_pausing_and_mouse()
			stickerbook.visible = !stickerbook.visible

# set initial visibility states
func _ready() -> void:
	set_initial_visibility()
	QuestManager.main_quest_completed.connect(_on_main_quest_completion, CONNECT_ONE_SHOT)
	transition()

func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pause_menu.visible = false

func _on_main_quest_completion() -> void:
	complete_stamp.visible = true
	
func transition():
	transition_color.visible = true
	await get_tree().create_timer(.1).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(transition_color, "modulate:a", 0.0, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.play()
	await tween.finished
	transition_color.visible = false
	transition_color.modulate.a = 1.0
	
func transition_soft_in():
	transition_color.visible = true
	transition_color.color = Color.BLACK
	var tween = get_tree().create_tween()
	tween.tween_property(transition_color, "modulate:a", 0.0, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.play()
	await tween.finished
	transition_color.visible = false
	transition_color.modulate.a = 1.0
