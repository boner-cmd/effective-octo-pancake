# TODO put the interaction prompt handling in this script
extends CanvasLayer

@onready var control_schematic_full: Control = $ControlSchematicFull
@onready var keyboard_controls_menu: Control = $PauseContainer/KeyboardControlsMenu
@onready var audio_control: VBoxContainer = $PauseContainer/MarginContainer/AudioControlVBox

@onready var map : TextureRect = %Map #map

@onready var pause_menu : Control = $PauseContainer #pause menu

@onready var transition_color: ColorRect = $ColorRect
@onready var DialogueVingette : TextureRect = $DialogueVignette
#interact
@onready var interact_Door : MarginContainer = $MarginContainer/Interact_Door_Open
@onready var interact_Lock : MarginContainer = $MarginContainer/Interact_Door_Locked
@onready var interact_NPC : MarginContainer = $MarginContainer/Interact_NPC
var temp_size : float
#labels
@onready var npc_label: Label = $MarginContainer/Interact_NPC/MarginContainer/NPC 

@onready var next_indicator: AnimatedSprite2D = $MarginContainer/Control/NextIndicator
@onready var next_indicator_label: Label = $MarginContainer/Control/NextIndicator/Label
#pause buttons
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


var current_npc
@onready var main_scene: Node3D = $".."

@onready var player : CharacterBody3D
@onready var player_rig : Node3D
@onready var interaction_detector

#var lock : bool = false

var temp_interact : bool = false
var temp_interact_pause : bool = false
var temp_interact_node : MarginContainer
@onready var transition_timer: Timer = $Timer
var TextBox : MarginContainer

var control_acknowledge : bool = true

enum PauseState {UNPAUSED, MAP, PAUSED, BOTH}
var current_PauseState : PauseState = PauseState.UNPAUSED


# set initial visibility states
func _ready() -> void:
	#change pivots for buttons
	quit_button.pivot_offset_ratio = Vector2(0.0, 0.5)
	continue_button.pivot_offset_ratio = Vector2(0.0, 0.5)
	menu_button.pivot_offset_ratio = Vector2(0.0, 0.5)
	pause_menu.pivot_offset_ratio = Vector2(0.0, 0.5)
	sound_button.pivot_offset_ratio = Vector2(0.0, 0.5)	
	#start initialization - transition into main scene from title
	set_initial_visibility()
	player = get_tree().get_first_node_in_group("Player")
	for node in player.get_children():
		if node.name == "ClownRigFBX":
			player_rig = node
	for node in player_rig.get_children():
		if node.name == "InteractionDetector":
			interaction_detector = node
	#connect signals for interact
	interaction_detector.exit_area_entered.connect(on_exit_door_entered)
	interaction_detector.exit_area_exited.connect(on_door_exited)
	interaction_detector.npc_entered.connect(on_npc_entered)
	interaction_detector.npc_exited.connect(on_npc_exited)
	#timer for transition start
	transition_timer.start()
	await transition_timer.timeout
	#transition stuff
	transition_color.self_modulate = Color(0.0,0.0,0.0,1.0)
	transition_color.visible = true
	#control schematics UI stuff here
	await get_tree().create_timer(.1).timeout
	tween_object(control_schematic_full, "modulate:a", 1.0, .2, Tween.TRANS_SINE, Tween.EASE_IN_OUT, true)
	control_acknowledge = false
	

# separated out in case more needs to go in _ready
func set_initial_visibility() -> void:
	visible = true
	map.visible = false
	pause_menu.visible = false
	transition_color.visible = true
	interact_Door.visible = false
	interact_Lock.visible = false
	interact_NPC.visible = false
	transition_color.visible = true
	control_schematic_full.visible = true
	control_schematic_full.modulate.a = 0.0
	audio_control.modulate.a = 0.0
	keyboard_controls_menu.modulate.a = 0.0


#pause states
func check_pause_state() -> void: #sets pause state probably unneccessary
	if pause_menu.visible:
		if map.visible:
			current_PauseState = PauseState.BOTH
		else:
			current_PauseState = PauseState.PAUSED
	else:
		if map.visible:
			current_PauseState = PauseState.MAP
		else:
			current_PauseState = PauseState.UNPAUSED
			

func change_pause_state() -> void:
	#when switching from state to another state
	match current_PauseState:
		PauseState.UNPAUSED:	#switching TO unpaused both
			get_tree().paused = false
			handle_temp_interact()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			for node in get_tree().get_nodes_in_group("UI_on_pause"):
				node.visible = true
			if pause_menu.visible == true:
				show_buttons()
				await tween_object(pause_menu, "modulate:a", 0.0, .2, Tween.TRANS_SINE, Tween.EASE_IN, true)
				pause_menu.visible = false
			if map.visible == true:
				map.modulate.a = 1.0
				await tween_object(map, "modulate:a", 0.0, .2, Tween.TRANS_SINE, Tween.EASE_IN, true)
				map.visible = false
			
		PauseState.MAP:			#switching TO map
			get_tree().paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			handle_temp_interact()
			if map.visible == false: #coming from unpaused
				for node in get_tree().get_nodes_in_group("UI_on_pause"):
					node.visible = false
				map.modulate.a = 0.0
				map.visible = true
				tween_object(map, "modulate:a", 1.0, .2, Tween.TRANS_SINE, Tween.EASE_OUT, true)
			elif pause_menu.visible == true: #coming from paused both
				show_buttons()
				await tween_object(pause_menu, "modulate:a", 0.0, .2, Tween.TRANS_SINE, Tween.EASE_IN, true)
				pause_menu.visible = false
				
		_:		#switching TO paused, switching TO both - turning pause menu visible regardless
			get_tree().paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			handle_temp_interact()
			for node in get_tree().get_nodes_in_group("UI_on_pause"):
				node.visible = false
			show_buttons()
			pause_menu.modulate.a = 0.0
			pause_menu.visible = true
			tween_object(pause_menu, "modulate:a", 1.0, .2, Tween.TRANS_SINE, Tween.EASE_OUT, true)




func handle_temp_interact() -> void:
	if current_PauseState == PauseState.UNPAUSED:
		if temp_interact_node:
			match temp_interact_node.name:
					"Interact_Door_Locked":
						interact_Lock.visible = true
					"Interact_Door_Open":
						interact_Door.visible = true
						next_indicator.visible = true
					"Interact_NPC":
						if temp_interact_pause == true:	#if the flag for temp interact is true
								if DialogueManager.is_dialogue_active == true:
									interact_NPC.visible = false
									next_indicator.visible = false
									temp_interact_pause = true
								else:
									interact_NPC.visible = true
									next_indicator.visible = true
									temp_interact_pause = false
					_:
						pass
	else:
		interact_Door.visible = false
		interact_Lock.visible = false
		interact_NPC.visible = false
		next_indicator.visible = false
		if temp_interact_node:
			match temp_interact_node.name:
				"Interact_NPC":
					temp_interact_pause = true
				_:
					pass


func tween_object(object, property : String, goal, time : float, transtype : Tween.TransitionType, easetype : Tween.EaseType, wait_finish : bool) -> void:
	var tweened_object = create_tween()
	var tweener_object = tweened_object.tween_property(object, property, goal, time)
	tweener_object.set_trans(transtype).set_ease(easetype)
	tweened_object.play()
	if wait_finish:
		await tweened_object.finished
		if tweened_object and tweened_object.is_valid():
			tweened_object.kill()


# DEBUG make sure node pause function is working
# DEBUG possibly a more elegant way to handle pausing from inventory? review here
func pause_tween() -> void:
	if pause_menu.visible: #hiding pause menu now
		#show_buttons() #enforce reset of buttons and menus
		# DEBUG check for incorrect stopwatch behavior here
		#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		#for node in get_tree().get_nodes_in_group("UI_on_pause"):
			#node.visible = true
		#interact_Door.visible = false
		#interact_Lock.visible = false
		#interact_NPC.visible = false
		
		
		#var tween_hide = create_tween()
		#var scale_down = tween_hide.tween_property(pause_menu, "modulate:a", 0.0, .2)
		#scale_down.set_trans(Tween.TRANS_SINE)
		#scale_down.set_ease(Tween.EASE_IN)
		#tween_hide.play()
		#await tween_hide.finished
		#pause_menu.visible = false
		pass
	else:#showing menu now
		#pause_menu.modulate.a = 0.0 #tween this instead
		#pause_menu.visible = true
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		#var tween_unhide = create_tween()
		#var scale_up = tween_unhide.tween_property(pause_menu, "modulate:a", 1.0, .2)
		#scale_up.set_trans(Tween.TRANS_SINE)
		#scale_up.set_ease(Tween.EASE_IN)
		#tween_unhide.play()
		#await tween_unhide.finished
		# DEBUG check for incorrect stopwatch behavior here
		#for button in get_tree().get_nodes_in_group("Pause_Buttons"):
			#button.visible = true
			#button.modulate.a = 1.0
		#for node in get_tree().get_nodes_in_group("UI_on_pause"):	#all this bullshit is for the interact visibility on pause reset
			#if temp_interact_node != null:
				#if node.name == temp_interact_node.name:
					#node.visible = false	#set to false
					#temp_interact_pause = true	#set flag to turn back on to true
				#else:
					#node.visible = false
		pass




func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_pause"):
		match current_PauseState:
			PauseState.UNPAUSED:
				current_PauseState = PauseState.PAUSED
			PauseState.PAUSED:
				current_PauseState = PauseState.UNPAUSED
			PauseState.MAP:
				current_PauseState = PauseState.BOTH
			PauseState.BOTH:
				current_PauseState = PauseState.MAP
		change_pause_state()
		
	if event.is_action_pressed("toggle_stickerbook"):
		match current_PauseState:
			PauseState.UNPAUSED:
				current_PauseState = PauseState.MAP
			PauseState.MAP:
				current_PauseState = PauseState.UNPAUSED
			_:
				pass
		change_pause_state()
	
	if event.is_action_pressed("advance_dialogue"):
		if interact_NPC.visible:
			if DialogueManager.is_dialogue_active == true:
				tween_interact_false(interact_NPC)
				next_indicator.visible = false
				next_indicator_label.visible = false
				next_indicator_label.modulate.a = 0.0
				temp_interact = true
				tween_vignette_switch(true)
		elif temp_interact:
			await get_tree().create_timer(.01).timeout
			if DialogueManager.is_dialogue_active == false:
				tween_vignette_switch(false)
				await get_tree().create_timer(.29).timeout
				tween_interact_true(interact_NPC)
				temp_interact = false
		#control_schematic
		if not control_acknowledge:
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




func _on_quit_button_pressed() -> void:
	#toggle_pausing()
	pause_tween()
	player_rig._set_player_anim(player_rig.AnimStates.VICTORY)
	current_PauseState = PauseState.UNPAUSED
	change_pause_state()
	#TODO auto save here probably
	
	await get_tree().create_timer(3).timeout
	transition()
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

func _on_continue_button_pressed() -> void:
	match current_PauseState:
		PauseState.PAUSED:
			current_PauseState = PauseState.UNPAUSED
			change_pause_state()
		PauseState.BOTH:
			current_PauseState = PauseState.MAP
			change_pause_state()
		_:
			pass
	AudioManager.sfx_play(AudioManager.sfx_blip)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pause_tween()
	if DialogueManager.is_dialogue_active == true:
		for node in get_children():
			if node.name == "TextBox":
				TextBox = node
				TextBox.visible = true
	if temp_interact == true:
		temp_interact_node.visible = true

func _on_controls_button_pressed() -> void:
	AudioManager.sfx_play(AudioManager.sfx_blip)
	if not controls_bool:
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
	if not sound_bool:
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
	#toggle_pausing()
	pause_tween()
	player_rig._set_player_anim(player_rig.AnimStates.VICTORY)
	#TODO auto save here probably
	
	await get_tree().create_timer(3).timeout
	transition()
	get_tree().root.remove_child(get_parent().current_planet)
	AudioManager.bgm_cycle(22)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file('res://Scenes/TitleScreen.tscn')

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
			button_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			tween.play()
			button.disabled = true
			button.mouse_filter = 2

func show_buttons() -> void: #for tweening buttons to be visible after returning to pause
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
	interact_NPC.visible = false
	interact_Lock.visible = false
	interact_Door.visible = false
	if lock_on_door:
		tween_interact_true(interact_Lock)
		temp_interact_node = interact_Lock
	else:
		tween_interact_true(interact_Door)
		temp_interact_node = interact_Door

func on_door_exited() -> void:
	interact_NPC.visible = false
	tween_interact_false(temp_interact_node)
	temp_interact_node = null
	next_indicator.visible = false

#TODO set tweens for intract visibility

func tween_interact_true(interactparent) -> void:
	next_indicator.visible = false
	next_indicator_label.visible = false
	next_indicator_label.modulate.a = 0.0
	var label_margin = interactparent.get_child(1)
	var label = label_margin.get_child(0)
	await get_tree().create_timer(.01).timeout
	label_margin.custom_minimum_size.x = 0.0
	label_margin.pivot_offset_ratio.x = .5
	interactparent.modulate.a = 0.0
	interactparent.visible = true
	label.visible = true
	await get_tree().create_timer(.01).timeout
	temp_size = label_margin.size.x
	await get_tree().create_timer(.01).timeout
	label.modulate.a = 0.0
	label.visible = false
	
	#tween modulate interactparent
	var tween_interact = get_tree().create_tween()
	var interact_tweener = tween_interact.tween_property(interactparent, "modulate:a", 1.0, .05)
	interact_tweener.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween_interact.play()
	await tween_interact.finished
	if tween_interact and tween_interact.is_valid():
		tween_interact.kill()
	#tween size:x
	var tween_interact_x = get_tree().create_tween()
	var interact_x_tweener = tween_interact_x.tween_property(label_margin, "custom_minimum_size:x", temp_size, .1)
	interact_x_tweener.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween_interact_x.play()
		
	await tween_interact_x.finished
	if tween_interact_x and tween_interact_x.is_valid():
		tween_interact_x.kill()
	
	if interactparent.name == "Interact_Door_Locked":
		pass
	else:
		next_indicator.stop()
		next_indicator.frame = 0
		next_indicator.visible = true
		next_indicator.play()
		next_indicator_label.visible = true
		var tween_interactlabel = get_tree().create_tween()
		var interactlabel_tweener = tween_interactlabel.tween_property(next_indicator_label, "modulate:a", 1.0, .1)
		interactlabel_tweener.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
		tween_interactlabel.play()
		
	
	label.visible = true
	#tween modulate label
	var tween_label = get_tree().create_tween()
	var label_tweener = tween_label.tween_property(label, "modulate:a", 1.0, .2)
	label_tweener.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween_label.play()
	await tween_label.finished
	if tween_label and tween_label.is_valid():
		tween_label.kill()

func tween_interact_false(interactparent) -> void:
	var label_margin = interactparent.get_child(1)
	var label = label_margin.get_child(0)
	next_indicator.visible = false
	
	label_margin.custom_minimum_size.x = temp_size
	label.visible = false
	
	#tween size to 0
	var tween_interact_x_down = get_tree().create_tween()
	var interact_x_down_tweener = tween_interact_x_down.tween_property(label_margin, "custom_minimum_size:x", 0.0, .3)
	interact_x_down_tweener.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween_interact_x_down.play()
	
	#await tween_interact_x_down.finished
	
	var tween_interact_mod = get_tree().create_tween()
	var interact_mod_tweener = tween_interact_mod.tween_property(interactparent, "modulate:a", 0.0, .1).set_delay(.15)
	interact_mod_tweener.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween_interact_mod.play()
	await tween_interact_mod.finished
	interactparent.visible = false
	
	if tween_interact_mod and tween_interact_mod.is_valid():
		tween_interact_mod.kill()
	if tween_interact_x_down and tween_interact_x_down.is_valid():
		tween_interact_x_down.kill()
		

func immediate_interact_false(interactparent) -> void:
	var label_margin = interactparent.get_child(1)
	var label = label_margin.get_child(0)
	label_margin.custom_minimum_size.x = 0.0
	next_indicator.visible = false
	interactparent.visible = false
	label.visible = false

func tween_vignette_switch(flag : bool) -> void:
	var alpha : float
	if flag:
		DialogueVingette.modulate.a = 0.0
		DialogueVingette.visible = true
		alpha = 1.0
	else:
		DialogueVingette.modulate.a = 1.0
		alpha = 0.0
		
	var tween_vignette = get_tree().create_tween()
	var vignette_tweener = tween_vignette.tween_property(DialogueVingette, "modulate:a", alpha, .5)
	vignette_tweener.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween_vignette.play()
	
	await tween_vignette.finished
	
	if not flag:
		DialogueVingette.visible = false

func on_npc_entered() -> void:
	tween_interact_true(interact_NPC)
	interact_Lock.visible = false
	interact_Door.visible = false
	temp_interact_node = interact_NPC
	npc_label.text = "Listen to " + DialogueManager.Character_Names[main_scene.current_planet_id]


func on_npc_exited() -> void:
	tween_interact_false(interact_NPC)
	interact_Lock.visible = false
	interact_Door.visible = false
	temp_interact_node = null
	next_indicator.visible = false


#button anims and sounds
func _on_continue_button_mouse_entered() -> void:
	AudioManager.sfx_play(AudioManager.sfx_blip)
	continue_button.scale = Vector2(1.1, 1.1)

func _on_continue_button_mouse_exited() -> void:
	continue_button.scale = Vector2(1.0, 1.0)
	

func _on_quit_button_mouse_entered() -> void:
	AudioManager.sfx_play(AudioManager.sfx_blip)
	quit_button.scale = Vector2(1.1, 1.1)

func _on_quit_button_mouse_exited() -> void:
	quit_button.scale = Vector2(1.0, 1.0)

func _on_sound_button_mouse_entered() -> void:
	AudioManager.sfx_play(AudioManager.sfx_blip)
	sound_button.scale = Vector2(1.1, 1.1)

func _on_sound_button_mouse_exited() -> void:
	sound_button.scale = Vector2(1.0, 1.0)

func _on_controls_button_mouse_entered() -> void:
	AudioManager.sfx_play(AudioManager.sfx_blip)
	controls_button.scale = Vector2(1.1, 1.1)

func _on_controls_button_mouse_exited() -> void:
	controls_button.scale = Vector2(1.0, 1.0)

func _on_menu_button_mouse_entered() -> void:
	AudioManager.sfx_play(AudioManager.sfx_blip)
	menu_button.scale = Vector2(1.1, 1.1)

func _on_menu_button_mouse_exited() -> void:
	menu_button.scale = Vector2(1.0, 1.0)
