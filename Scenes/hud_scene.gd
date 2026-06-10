# TODO put the interaction prompt handling in this script
extends CanvasLayer

@onready var control_schematic_full: Control = $ControlSchematicFull
@onready var keyboard_controls_menu: Control = $PauseContainer/KeyboardControlsMenu
@onready var audio_control: VBoxContainer = $PauseContainer/MarginContainer/AudioControlVBox

@onready var stickerbook : TextureRect = %Map #map

@onready var pause_menu : MarginContainer = $PauseContainer #pause menu

@onready var inventory : MarginContainer = $InventoryBackgroundMargin # inventory

@onready var transition_color: ColorRect = $ColorRect
#interact
@onready var interact: MarginContainer = $Interact
#labels
@onready var exit_label: Label = $Interact/MarginContainer/ExitLabel
@onready var locked_label: Label = $Interact/MarginContainer/LockedLabel
@onready var npc_label: Label = $Interact/MarginContainer/NPC 
@onready var next_indicator: AnimatedSprite2D = $Interact/MarginContainer/NextIndicator
#buttons
@onready var continue_button: TextureButton = $PauseContainer/MarginContainer/ButtonContainerVBox/ContinueButton
@onready var quit_button: TextureButton = $PauseContainer/MarginContainer/ButtonContainerVBox/QuitButton
@onready var sound_button: TextureButton = $PauseContainer/MarginContainer/ButtonContainerVBox/Sound_Wrap/SoundButton
@onready var controls_button: TextureButton = $PauseContainer/MarginContainer/ButtonContainerVBox/Controls_Wrap/ControlsButton
@onready var menu_button: TextureButton = $PauseContainer/MarginContainer/ButtonContainerVBox/MenuButton
var continue_bool : bool = false
var quit_bool : bool = false
var sound_bool : bool = false
var controls_bool : bool = false
var menu_bool : bool = false
var pause_bool : bool = false


var current_npc
@onready var main_scene: Node3D = $".."

@onready var player : CharacterBody3D
@onready var interaction_detector

#var lock : bool = false

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
			
			
		#turn this into a function so we can call it from continue button pressed
		if pause_menu.visible: #hiding menu now
			show_buttons() #enforce reset of buttons
			#if event.is_action_pressed("toggle_pause"):
			var tween_hide = get_tree().create_tween()
			var scale_down = tween_hide.tween_property(pause_menu, "scale", Vector2(0.01,0.01), .2)
			scale_down.set_trans(Tween.TRANS_SINE)
			scale_down.set_ease(Tween.EASE_IN)
			tween_hide.play()
			await tween_hide.finished
			pause_menu.visible = false
			pause_bool = false
			
		else:#showing menu now
			pause_menu.scale = Vector2(1.0,1.0) #tween this instead
			pause_menu.visible = true
			QuestManager.track_time = false #stop game timer
			for button in get_tree().get_nodes_in_group("Pause_Buttons"):
				button.visible = true
				button.modulate.a = 1.0
			pause_bool = true
			
			
			
			
			
		for node in get_children():					#all this bullshit is for the interact visibility on pause reset
			if node.is_in_group("UI_on_pause"):
				if pause_menu.visible: 				#paused
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
	#change pivots for buttons
	quit_button.pivot_offset_ratio = Vector2(0.5, 0.5)
	continue_button.pivot_offset_ratio = Vector2(0.5, 0.5)
	menu_button.pivot_offset_ratio = Vector2(0.5, 0.5)
	keyboard_controls_menu.modulate.a = 0.0
	pause_menu.pivot_offset_ratio = Vector2(0.5, 0.5)
	#start initialization - transition into main scene from title
	transition_color.visible = true
	set_initial_visibility()
	QuestManager.main_quest_completed.connect(_on_main_quest_completion, CONNECT_ONE_SHOT)
	player = get_tree().get_first_node_in_group("Player")
	interaction_detector = player.get_child(2).get_child(4)
	#connect signals for interact
	interaction_detector.exit_area_entered.connect(on_exit_door_entered)
	interaction_detector.exit_area_exited.connect(on_door_exited)
	interaction_detector.npc_entered.connect(on_npc_entered)
	interaction_detector.npc_exited.connect(on_npc_exited)
	#timer for transition start
	timer.start()
	await timer.timeout
	#transition stuff
	transition_color.self_modulate = Color(0.0,0.0,0.0,1.0)
	transition_color.visible = true
	#control schematics UI stuff here
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
	audio_control.modulate.a = 0.0
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

func _on_controls_button_pressed() -> void:
	AudioManager.sfx_play(AudioManager.sfx_blip)
	if !controls_bool:
		controls_bool = true
		tween_button(controls_button)
		hide_other_buttons(controls_button)
		keyboard_controls_menu.visible = true
		var tween = create_tween()
		var show_controls = tween.tween_property(keyboard_controls_menu, "modulate:a", 1.0, .5)
		show_controls.set_trans(Tween.TRANS_SINE)
		show_controls.set_ease(Tween.EASE_IN)
		tween.play()
	else:
		controls_bool = false
		var tween = create_tween()
		var hide_controls = tween.tween_property(keyboard_controls_menu, "modulate:a", 0.0, .5)
		hide_controls.set_trans(Tween.TRANS_SINE)
		hide_controls.set_ease(Tween.EASE_IN)
		tween.play()
		tween_button(controls_button)
		await tween.finished
		keyboard_controls_menu.visible = false
		show_buttons()
		

func _on_sound_button_pressed() -> void:
	AudioManager.sfx_play(AudioManager.sfx_blip)
	if !sound_bool:
		sound_bool = true
		tween_button(sound_button)
		hide_other_buttons(sound_button)
		audio_control.visible = true
		var tween = create_tween()
		var show_controls = tween.tween_property(audio_control, "modulate:a", 1.0, .5)
		show_controls.set_trans(Tween.TRANS_SINE)
		show_controls.set_ease(Tween.EASE_IN)
		tween.play()
	else:
		sound_bool = false
		var tween = create_tween()
		var hide_controls = tween.tween_property(audio_control, "modulate:a", 0.0, .5)
		hide_controls.set_trans(Tween.TRANS_SINE)
		hide_controls.set_ease(Tween.EASE_IN)
		tween.play()
		tween_button(sound_button)
		await  tween.finished
		show_buttons()

func _on_menu_button_pressed() -> void:
	AudioManager.sfx_play(AudioManager.sfx_blip)
	

func tween_button(selected_button) -> void:
	var goal : float = 0.0
	if selected_button.name == "ControlsButton":
		if controls_bool:
			goal = 194.0
		else:
			goal = 0.0
	if selected_button.name == "SoundButton":
		if sound_bool:
			goal = 292.0
		else:
			goal = 0.0
	var tween = create_tween()
	var tween_btn = tween.tween_property(selected_button, "position:y", goal, 1)
	tween_btn.set_trans(Tween.TRANS_BOUNCE)
	tween_btn.set_ease(Tween.EASE_OUT)
	
	
	tween.play()
	await tween.finished
	if tween and tween.is_valid():
		tween.kill()


func hide_other_buttons(selected_button) -> void:
	for button in get_tree().get_nodes_in_group("Pause_Buttons"):
		if button.name != selected_button.name:
			var tween = create_tween()
			var button_tween = tween.tween_property(button, "modulate:a", 0.0, .5)
			button_tween.set_trans(Tween.TRANS_SINE)
			button_tween.set_ease(Tween.EASE_OUT)
			tween.play()
			button.disabled = true
			button.mouse_filter = 2

func show_buttons() -> void:
	for button in get_tree().get_nodes_in_group("Pause_Buttons"):
		var tween = create_tween()
		var button_tween = tween.tween_property(button, "modulate:a", 1.0, .25)
		button_tween.set_trans(Tween.TRANS_SINE)
		button_tween.set_ease(Tween.EASE_OUT)
		tween.play()
		button.disabled = false
		button.mouse_filter = 0
	controls_button.position.y = 0.0
	sound_button.position.y = 0.0
	keyboard_controls_menu.visible = false
	keyboard_controls_menu.modulate.a = 0.0
	controls_bool = false
	audio_control.visible = false
	audio_control.modulate.a = 0.0
	sound_bool = false

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

#TODO set tweens for intract visibility
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


#button anims and sounds
func _on_continue_button_mouse_entered() -> void:
	AudioManager.sfx_play(AudioManager.sfx_blip)
	continue_button.scale = Vector2(1.25, 1.25)

func _on_continue_button_mouse_exited() -> void:
	continue_button.scale = Vector2(1.0, 1.0)

func _on_quit_button_mouse_entered() -> void:
	AudioManager.sfx_play(AudioManager.sfx_blip)
	quit_button.scale = Vector2(1.25, 1.25)

func _on_quit_button_mouse_exited() -> void:
	quit_button.scale = Vector2(1.0, 1.0)

func _on_sound_button_mouse_entered() -> void:
	AudioManager.sfx_play(AudioManager.sfx_blip)
	sound_button.scale = Vector2(1.25, 1.25)

func _on_sound_button_mouse_exited() -> void:
	sound_button.scale = Vector2(1.0, 1.0)

func _on_controls_button_mouse_entered() -> void:
	AudioManager.sfx_play(AudioManager.sfx_blip)
	controls_button.scale = Vector2(1.25, 1.25)

func _on_controls_button_mouse_exited() -> void:
	controls_button.scale = Vector2(1.0, 1.0)

func _on_menu_button_mouse_entered() -> void:
	AudioManager.sfx_play(AudioManager.sfx_blip)
	menu_button.scale = Vector2(1.25, 1.25)

func _on_menu_button_mouse_exited() -> void:
	menu_button.scale = Vector2(1.0, 1.0)
