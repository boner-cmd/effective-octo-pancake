# TODO put the interaction prompt handling in this script
extends CanvasLayer

@onready var control_schematic_full: Control = $ControlSchematicFull

@onready var stickerbook : TextureRect = %Map
@onready var pause_menu : MarginContainer = $PauseContainer
@onready var inventory : MarginContainer = $InventoryBackgroundMargin
@onready var transition_color: ColorRect = $ColorRect
@onready var interact: MarginContainer = $Interact
@onready var exit_label: Label = $Interact/MarginContainer/ExitLabel
@onready var locked_label: Label = $Interact/MarginContainer/LockedLabel
@onready var npc_label: Label = $Interact/MarginContainer/NPC 
@onready var next_indicator: AnimatedSprite2D = $Interact/MarginContainer/NextIndicator
@onready var continue_button: TextureButton = $PauseContainer/MarginContainer/HBoxContainer/ContinueButton
@onready var quit_button: TextureButton = $PauseContainer/MarginContainer/HBoxContainer/QuitButton
var current_npc
@onready var main_scene: Node3D = $".."

@onready var player : CharacterBody3D
@onready var interaction_detector
var lock : bool = false
var temp_interact : bool = false
var temp_interact_pause : bool = false
@onready var timer: Timer = $Timer
var Nametag : MarginContainer
var TextBox : MarginContainer

var control_acknowledge : bool = true

# separated out in case more needs to go in _ready
func set_initial_visibility() -> void:
	visible = true
	stickerbook.visible = false
	pause_menu.visible = false
	transition_color.visible = true
	interact.visible = false
	control_schematic_full.visible = true
	control_schematic_full.modulate.a = 0.0
	
	
func toggle_pausing_and_mouse() -> void:
	get_tree().paused = !get_tree().paused
	Input.set_mouse_mode(Input.mouse_mode ^ Input.MOUSE_MODE_VISIBLE ^ Input.MOUSE_MODE_CAPTURED)
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_pause"):
		if !stickerbook.visible: # relying on pause and mouse state already set if stickerbook visible
			toggle_pausing_and_mouse()
		pause_menu.visible = !pause_menu.visible
		for node in get_children():
			if node.is_in_group("UI_on_pause"):
				if pause_menu.visible: 				#paused
					QuestManager.track_time = false
					if node.name == "Interact":
						if node.visible == true:	#if interact is visible
							node.visible = false	#set to false
							temp_interact_pause = true	#set flag to turn back on to true
					else:
						node.visible = false		#set everything else to false
				else:								#unpause
					QuestManager.track_time = true
					if node.name == "Interact":		
						if temp_interact_pause == true:	#if the flag for temp interact is true
							if DialogueManager.is_dialogue_active == true:
								node.visible = false
								temp_interact_pause = true
							else:
								node.visible = true
								temp_interact_pause = false
					else:
						node.visible = true
			
	if event.is_action_pressed("toggle_stickerbook"):
		if !pause_menu.visible: # don't allow showing the stickerbook while paused
			toggle_pausing_and_mouse()
			stickerbook.visible = !stickerbook.visible
			inventory.visible = !inventory.visible
		if stickerbook.visible:
			QuestManager.track_time = false
		else:
			QuestManager.track_time = true
	if event.is_action_pressed("advance_dialogue"):
		if interact.visible:
			if DialogueManager.is_dialogue_active == true:
				interact.visible = false
				temp_interact = true
		elif temp_interact:
			await get_tree().create_timer(.01).timeout
			if DialogueManager.is_dialogue_active == false:
				interact.visible = true
				temp_interact = false
		#control_schematic
		if !control_acknowledge:
			control_acknowledge = true
			var tween_control_off = get_tree().create_tween()
			tween_control_off.tween_property(control_schematic_full, "modulate:a", 0.0, .3)
			tween_control_off.set_trans(Tween.TRANS_SINE)
			tween_control_off.set_ease(Tween.EASE_IN_OUT)
			await get_tree().create_timer(.1).timeout
			tween_control_off.play()
			await tween_control_off.finished
			if tween_control_off and tween_control_off.is_valid():
				tween_control_off.kill()
			control_schematic_full.queue_free()
			transition()
			
		
# set initial visibility states
func _ready() -> void:
	quit_button.pivot_offset = quit_button.size / 2.0
	continue_button.pivot_offset = continue_button.size / 2.0
	transition_color.visible = true
	set_initial_visibility()
	QuestManager.main_quest_completed.connect(_on_main_quest_completion, CONNECT_ONE_SHOT)
	player = get_parent().get_child(1)
	interaction_detector = player.get_child(2).get_child(4)
	interaction_detector.exit_area_entered.connect(on_exit_door_entered)
	interaction_detector.exit_area_exited.connect(on_door_exited)
	interaction_detector.npc_entered.connect(on_npc_entered)
	interaction_detector.npc_exited.connect(on_npc_exited)
	timer.start()
	await timer.timeout
	#transition stuff
	transition_color.self_modulate = Color(0.0,0.0,0.0,1.0)
	transition_color.visible = true
	#control schematic stuff here
	var tween_control_on = get_tree().create_tween()
	tween_control_on.tween_property(control_schematic_full, "modulate:a", 1.0, .3)
	tween_control_on.set_trans(Tween.TRANS_SINE)
	tween_control_on.set_ease(Tween.EASE_IN_OUT)
	await get_tree().create_timer(.1).timeout
	tween_control_on.play()
	await tween_control_on.finished
	if tween_control_on and tween_control_on.is_valid():
		tween_control_on.kill()
	control_acknowledge = false
	#transition()

func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	AudioManager.sfx_play(AudioManager.sfx_blip)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pause_menu.visible = false
	if DialogueManager.is_dialogue_active == true:
		for node in get_children():
				if node.name == "TextBox":
					TextBox = node
					TextBox.visible = true
	if temp_interact == true:
		interact.visible = true

func _on_main_quest_completion() -> void:
#	complete_stamp.visible = true
	pass
	
func transition() -> void:
	transition_color.self_modulate = Color(0.0,0.0,0.0,1.0)
	transition_color.visible = true
	var tween_transition = get_tree().create_tween()
	tween_transition.tween_property(transition_color, "modulate:a", 0.0, .3)
	tween_transition.set_trans(Tween.TRANS_SINE)
	tween_transition.set_ease(Tween.EASE_IN_OUT)
	await get_tree().create_timer(.1).timeout
	tween_transition.play()
	await tween_transition.finished
	transition_color.visible = false
	transition_color.modulate.a = 1.0
	if tween_transition and tween_transition.is_valid():
		tween_transition.kill()

func on_exit_door_entered(lock_on_door) -> void:
	interact.visible = true
	npc_label.visible = false
	if lock_on_door:
		locked_label.visible = true
		exit_label.visible = false
		next_indicator.visible = false
	else:
		locked_label.visible = false
		exit_label.visible = true
		next_indicator.visible = true

func on_door_exited() -> void:
	interact.visible = false
	exit_label.visible = false
	locked_label.visible = false
	next_indicator.visible = false

#TO-DO set tweens for intract visibility
func on_npc_entered() -> void:
	interact.visible = true
	exit_label.visible = false
	locked_label.visible = false
	npc_label.visible = true
	npc_label.text = "Listen to " + DialogueManager.Character_Names[main_scene.current_planet_id]
	next_indicator.visible = true

func on_npc_exited() -> void:
	interact.visible = false
	npc_label.visible = false
	next_indicator.visible = false

func _on_continue_button_mouse_entered() -> void:
	AudioManager.sfx_play(AudioManager.sfx_blip)
	continue_button.scale = Vector2(1.2, 1.2)

func _on_continue_button_mouse_exited() -> void:
	continue_button.scale = Vector2(1.0, 1.0)

func _on_quit_button_mouse_entered() -> void:
	AudioManager.sfx_play(AudioManager.sfx_blip)
	quit_button.scale = Vector2(1.2, 1.2)

func _on_quit_button_mouse_exited() -> void:
	quit_button.scale = Vector2(1.0, 1.0)
