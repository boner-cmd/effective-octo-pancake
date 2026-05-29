# TODO put the interaction prompt handling in this script
extends CanvasLayer

@onready var stickerbook : TextureRect = $StickerbookBackground
@onready var pause_menu : NinePatchRect = $PauseBackground
@onready var complete_stamp : TextureRect = $StickerbookBackground/CompleteStamp
@onready var transition_color: ColorRect = $ColorRect
@onready var interact: MarginContainer = $Interact
@onready var exit_label: Label = $Interact/MarginContainer/ExitLabel
@onready var locked_label: Label = $Interact/MarginContainer/LockedLabel
@onready var npc_label: Label = $Interact/MarginContainer/NPC

@onready var player : CharacterBody3D
@onready var interaction_detector
var lock : bool = false

# separated out in case more needs to go in _ready
func set_initial_visibility() -> void:
	visible = true
	stickerbook.visible = false
	pause_menu.visible = false
	complete_stamp.visible = false
	transition_color.visible = false
	interact.visible = false
	
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
	if event.is_action_pressed("advance_dialogue"):
		if interact.visible:
			if DialogueManager.is_dialogue_active == true:
				interact.visible = false
			else:
				interact.visible = true

# set initial visibility states
func _ready() -> void:
	set_initial_visibility()
	QuestManager.main_quest_completed.connect(_on_main_quest_completion, CONNECT_ONE_SHOT)
	transition()
	player = get_parent().get_child(1)
	interaction_detector = player.get_child(2).get_child(4)
	interaction_detector.exit_area_entered.connect(on_exit_door_entered)
	interaction_detector.exit_area_exited.connect(on_door_exited)
	interaction_detector.npc_entered.connect(on_npc_entered)
	interaction_detector.npc_exited.connect(on_npc_exited)

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
	
func transition() -> void:
	transition_color.visible = true
	await get_tree().create_timer(.1).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(transition_color, "modulate:a", 0.0, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.play()
	await tween.finished
	transition_color.visible = false
	transition_color.modulate.a = 1.0
	
func transition_soft_in() -> void:
	transition_color.visible = true
	transition_color.color = Color.BLACK
	var tween = get_tree().create_tween()
	tween.tween_property(transition_color, "modulate:a", 0.0, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.play()
	await tween.finished
	transition_color.visible = false
	transition_color.modulate.a = 1.0

func on_exit_door_entered(lock_on_door) -> void:
	interact.visible = true
	npc_label.visible = false
	if lock_on_door:
		locked_label.visible = true
		exit_label.visible = false
	else:
		locked_label.visible = false
		exit_label.visible = true
		
func on_door_exited() -> void:
	interact.visible = false
	exit_label.visible = false
	locked_label.visible = false
		
func on_npc_entered() -> void:
	interact.visible = true
	exit_label.visible = false
	locked_label.visible = false
	npc_label.visible = true
	
func on_npc_exited() -> void:
	interact.visible = false
	npc_label.visible = false
	
