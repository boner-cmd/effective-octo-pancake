# TODO put the interaction prompt handling in this script
extends CanvasLayer

enum PAUSESTATE {UNPAUSED, MAP, PAUSED, MAP_PAUSED}
enum INTERACT_TYPE {NONE, DOOR_LOCKED, DOOR_OPEN, NPC}

var assert_interact_timer : Timer
var temp_size : float

# TODO replace this with the INTERACT_TYPE enum
var temp_interact_node : MarginContainer

var continue_bool : bool = false
var quit_bool : bool = false
var sound_bool : bool = false
var controls_bool : bool = false
var menu_bool : bool = false
var assert_timer : bool = false
var control_acknowledge : bool = true

#  TODO review these
var interaction_latch : bool = false

# default states for state trackers
var pause_state : PAUSESTATE = PAUSESTATE.UNPAUSED
var interact_touched : INTERACT_TYPE = INTERACT_TYPE.NONE

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var player_rig = player.clown
@onready var interaction_detector : Area3D = player_rig.get_child(player_rig.get_children().find_custom(func(n : Node): return n.name == "InteractionDetector"))

@onready var main_scene: Node3D = $".."
@onready var control_schematic_full: Control = $ControlSchematicFull
@onready var keyboard_controls_menu: Control = %KeyboardControlsMenu
@onready var audio_control: VBoxContainer = %AudioControlVBox
@onready var map : TextureRect = %Map
@onready var pause_menu : Control = $PauseContainer
@onready var transition_color: ColorRect = $ColorRect
@onready var dialogue_vignette : TextureRect = $DialogueVignette
@onready var interact_door_open : MarginContainer = %InteractDoorOpen
@onready var interact_door_locked : MarginContainer = %InteractDoorLocked
@onready var interact_npc_margin : MarginContainer = %InteractNPCMargin
@onready var npc_label: Label = %InteractNPCLabel 
@onready var next_indicator: AnimatedSprite2D = %NextIndicator
@onready var next_indicator_label: Label = %NextIndicatorLabel

#pause menu buttons
@onready var continue_button: TextureButton = %ContinueButton
@onready var quit_button: TextureButton = %QuitButton
@onready var sound_button: TextureButton = %SoundButton
@onready var controls_button: TextureButton = %ControlsButton
@onready var menu_button: TextureButton = %MenuButton

@onready var transition_timer: Timer = $Timer

## TODO documentation
func _ready() -> void:
	# set default visiblity states and modulation
	visible = true
	map.visible = false
	pause_menu.visible = false
	transition_color.visible = true
	interact_door_open.visible = false
	interact_door_locked.visible = false
	interact_npc_margin.visible = false
	transition_color.visible = true
	control_schematic_full.visible = true
	control_schematic_full.modulate.a = 0.0
	audio_control.modulate.a = 0.0
	keyboard_controls_menu.modulate.a = 0.0

	quit_button.pivot_offset_ratio = Vector2(0.0, 0.5)
	continue_button.pivot_offset_ratio = Vector2(0.0, 0.5)
	menu_button.pivot_offset_ratio = Vector2(0.0, 0.5)
	pause_menu.pivot_offset_ratio = Vector2(0.0, 0.5)
	sound_button.pivot_offset_ratio = Vector2(0.0, 0.5)
	
	audio_control.position.y = -50.0

	#connect signals for interact
	interaction_detector.exit_area_entered.connect(_on_exit_door_entered)
	interaction_detector.exit_area_exited.connect(_on_door_exited)
	interaction_detector.npc_entered.connect(_on_npc_entered)
	interaction_detector.npc_exited.connect(_on_npc_exited)
	
	#connect mouse area blips and effects
	for button in get_tree().get_nodes_in_group("Pause_Buttons"):
		button.mouse_entered.connect(_on_any_mouse_button_entered, CONNECT_APPEND_SOURCE_OBJECT)
		button.mouse_exited.connect(_on_any_mouse_button_exited, CONNECT_APPEND_SOURCE_OBJECT)

	#timer for transition start
	transition_timer.start()
	await transition_timer.timeout

	#transition coloration
	transition_color.self_modulate = Color(0.0,0.0,0.0,1.0)
	transition_color.visible = true

	#control schematics UI stuff here
	await get_tree().create_timer(.1).timeout
	tween_object(control_schematic_full, "modulate:a", 1.0, .2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	control_acknowledge = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_pause"):
		if alpha_modulated(pause_menu):
			change_pause_state()

	if event.is_action_pressed("toggle_map"):
		if alpha_modulated(map):
			match pause_state:
				PAUSESTATE.UNPAUSED:
					# update the state
					pause_state = PAUSESTATE.MAP
					# show the map
					get_tree().paused = true
					# hide dialog boxes
					hide_minor_ui()
					map.modulate.a = 0.0
					
					## TODO necessary?
					interact_door_open.visible = false
					interact_door_locked.visible = false
					interact_npc_margin.visible = false
					next_indicator.visible = false
					
					map.visible = true
					await tween_object(map, "modulate:a", 1.0, .2, Tween.TRANS_SINE, Tween.EASE_OUT)
					
				PAUSESTATE.MAP:
					# update the state
					pause_state = PAUSESTATE.UNPAUSED
					# hide the map
					get_tree().paused = false
					# restore dialog boxes
					show_minor_ui()
					map.modulate.a = 1.0
					await tween_object(map, "modulate:a", 0.0, .2, Tween.TRANS_SINE, Tween.EASE_IN)
					map.visible = false
				_:
					pass
					# do nothing if the pause screen is up

	if event.is_action_pressed("advance_dialogue"):
		## control schematic
		## TODO Mike says there are updates to be made here
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

		if interact_npc_margin.visible:
			if DialogueManager.is_dialogue_active:
				deactivate_tween_interact(interact_npc_margin)
				next_indicator.visible = false
				next_indicator_label.visible = false
				next_indicator_label.modulate.a = 0.0
				interaction_latch = true
				tween_vignette_switch(true) # does this need an await?
				interact_npc_margin.visible = false
		elif interaction_latch:
			print("entered latch ", next_indicator.visible)
			await get_tree().create_timer(.05).timeout
			if not DialogueManager.is_dialogue_active:
				interact_npc_margin.visible = true
				tween_vignette_switch(false)
				await get_tree().create_timer(.29).timeout
				activate_tween_interact(interact_npc_margin)
				interaction_latch = false


func _on_quit_button_pressed() -> void:
	player_rig._set_player_anim(player_rig.AnimStates.VICTORY)
	change_pause_state()
	#TODO auto save here probably
	
	await get_tree().create_timer(3).timeout
	transition()
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()


func _on_continue_button_pressed() -> void:
	change_pause_state()
	AudioManager.sfx_play(AudioManager.sfx_blip)


func _on_controls_button_pressed() -> void:
	AudioManager.sfx_play(AudioManager.sfx_blip)
	if not controls_bool:
		controls_bool = true
		tween_object(controls_button, "position:y", 194.0, 1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
		hide_other_buttons(controls_button)
		keyboard_controls_menu.visible = true
		tween_object(keyboard_controls_menu, "modulate:a", 1.0, .5, Tween.TRANS_SINE, Tween.EASE_IN)
	else:
		controls_bool = false
		tween_object(controls_button, "position:y", 0.0, 1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
		tween_object(keyboard_controls_menu, "modulate:a", 0.0, .5, Tween.TRANS_SINE, Tween.EASE_IN)
		await get_tree().create_timer(.5).timeout
		keyboard_controls_menu.visible = false
		reset_pause_menu()


func _on_sound_button_pressed() -> void:
	AudioManager.sfx_play(AudioManager.sfx_blip)
	if not sound_bool:
		sound_bool = true
		tween_object(sound_button, "position:y", 292.0, 1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
		hide_other_buttons(sound_button)
		audio_control.visible = true
		tween_object(audio_control, "modulate:a", 1.0, .5, Tween.TRANS_SINE, Tween.EASE_IN)
	else:
		sound_bool = false
		tween_object(audio_control, "modulate:a", 0.0, .5, Tween.TRANS_SINE, Tween.EASE_IN)
		tween_object(sound_button, "position:y", 0.0, 1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
		await get_tree().create_timer(.5).timeout
		reset_pause_menu()


## main menu button
func _on_menu_button_pressed() -> void:
	AudioManager.sfx_play(AudioManager.sfx_blip)
	change_pause_state()
	player_rig._set_player_anim(player_rig.AnimStates.VICTORY)
	#TODO auto save here probably
	
	await get_tree().create_timer(3).timeout
	transition()
	get_tree().root.remove_child(get_parent().current_planet)
	AudioManager.bgm_cycle(22)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file('uid://duig5pisbnbl8')


func _on_any_mouse_button_entered(source : Object) -> void:
	AudioManager.sfx_play(AudioManager.sfx_blip)
	source.scale = Vector2(1.1, 1.1)


func _on_any_mouse_button_exited(source : Object) -> void:
	source.scale = Vector2(1.0, 1.0)


func _on_npc_entered() -> void:
	activate_tween_interact(interact_npc_margin)
	#interact_door_locked.visible = false # relates to when player touches door and NPC
	#interact_door_open.visible = false # relates to when player touches door and NPC
	npc_label.text = "Listen to " + DialogueManager.Character_Names[main_scene.current_planet_id]
	interact_touched = INTERACT_TYPE.NPC


func _on_npc_exited() -> void:
	deactivate_tween_interact(interact_npc_margin)
	#interact_door_locked.visible = false # relates to when player touches door and NPC
	#interact_door_open.visible = false # relates to when player touches door and NPC
	interact_touched = INTERACT_TYPE.NONE


func _on_door_exited() -> void:
	#interact_npc_margin.visible = false # relates to when player touches door and NPC
	match interact_touched:
		INTERACT_TYPE.DOOR_LOCKED:
			deactivate_tween_interact(interact_door_locked)
		INTERACT_TYPE.DOOR_OPEN:
			deactivate_tween_interact(interact_door_open)
	interact_touched = INTERACT_TYPE.NONE
	next_indicator.visible = false


func _on_exit_door_entered(lock_on_door : bool) -> void:
	interact_npc_margin.visible = false
	interact_door_locked.visible = false
	interact_door_open.visible = false
	if lock_on_door:
		activate_tween_interact(interact_door_locked)
		interact_touched = INTERACT_TYPE.DOOR_LOCKED
	else:
		activate_tween_interact(interact_door_open)
		interact_touched = INTERACT_TYPE.DOOR_OPEN

func alpha_modulated(c : Control) -> bool:
	if c.modulate.a == 1.0 or c.modulate.a == 0.0: 
		return true
	return false

func hide_other_buttons(selected_button : TextureButton) -> void:
	get_tree().get_nodes_in_group("Pause_Buttons").all(func (b : TextureButton): 
			if b.name != selected_button.name:
				tween_object(b, "modulate:a", 0.0, .5, Tween.TRANS_SINE, Tween.EASE_OUT)
				b.disabled = true
				b.mouse_filter = Control.MOUSE_FILTER_IGNORE
			return true)


func change_pause_state() -> void:
	match pause_state:
		# UNPAUSED -> PAUSED
		PAUSESTATE.UNPAUSED:
			pause_state = PAUSESTATE.PAUSED
			pause_game()
		
		# MAP -> MAP_PAUSED
		PAUSESTATE.MAP:
			pause_state = PAUSESTATE.MAP_PAUSED
			pause_game()
		
		# PAUSED -> UNPAUSED
		PAUSESTATE.PAUSED:
			pause_state = PAUSESTATE.UNPAUSED
			get_tree().paused = false
			restore_game()
		
		# MAP_PAUSED -> MAP
		PAUSESTATE.MAP_PAUSED:
			# leaving the MAP_PAUSED state to enter the MAP state
			pause_state = PAUSESTATE.MAP
			restore_game()


## TODO description
func pause_game() -> void:
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	hide_minor_ui()
	reset_pause_menu()
	pause_menu.modulate.a = 0.0
	pause_menu.visible = true
	tween_object(pause_menu, "modulate:a", 1.0, .2, Tween.TRANS_SINE, Tween.EASE_OUT)


## TODO description
func restore_game() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	show_minor_ui()
	reset_pause_menu()
	await tween_object(pause_menu, "modulate:a", 0.0, .2, Tween.TRANS_SINE, Tween.EASE_IN)
	pause_menu.visible = false


## hides TextBox, Nametag, and InteractMargin
func hide_minor_ui() -> void:
	get_tree().get_nodes_in_group("UI_on_pause").all(func (n : Node): 
			n.visible = false
			return true)


## shows TextBox, Nametag, and InteractMargin
func show_minor_ui() -> void:
	get_tree().get_nodes_in_group("UI_on_pause").all(func (n : Node): 
			n.visible = true
			return true)


func tween_object(object : Object, property : NodePath, goal : Variant, time : float, 
			transtype : Tween.TransitionType, easetype : Tween.EaseType) -> void:
	var tweened_object = create_tween()
	var tweener_object = tweened_object.tween_property(object, property, goal, time)
	tweener_object.set_trans(transtype).set_ease(easetype)
	tweened_object.play()
	await tweened_object.finished
	if tweened_object and tweened_object.is_valid():
		tweened_object.kill()


## for tweening buttons to be visible after returning to pause
func reset_pause_menu() -> void:
	get_tree().get_nodes_in_group("Pause_Buttons").all(func(b : Object):
			tween_object(b, "modulate:a", 1.0, .25, Tween.TRANS_SINE, Tween.EASE_OUT)
			b.disabled = false
			b.mouse_filter = Control.MOUSE_FILTER_STOP
			return true
			)

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
	await get_tree().create_timer(.1).timeout
	await tween_object(transition_color, "modulate:a", 0.0, .3, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	transition_color.visible = false
	transition_color.modulate.a = 1.0


func activate_tween_interact(interact_parent : MarginContainer) -> void:
	next_indicator.visible = false
	next_indicator_label.visible = false
	next_indicator_label.modulate.a = 0.0
	var label_margin = interact_parent.get_child(1)
	var label = label_margin.get_child(0)
	await get_tree().create_timer(.05).timeout
	label_margin.custom_minimum_size.x = 0.0
	label_margin.pivot_offset_ratio.x = .5
	interact_parent.modulate.a = 0.0
	interact_parent.visible = true
	label.visible = true
	await get_tree().create_timer(.05).timeout
	temp_size = label_margin.size.x
	await get_tree().create_timer(.05).timeout
	label.modulate.a = 0.0
	label.visible = false
	#tween modulate interact_parent
	await tween_object(interact_parent, "modulate:a", 1.0, .05, Tween.TRANS_SINE, Tween.EASE_IN)
	#tween size:x
	await tween_object(label_margin, "custom_minimum_size:x", temp_size, .1, Tween.TRANS_SINE, Tween.EASE_IN)
	
	if not interact_parent.name == "InteractDoorLocked":
		next_indicator.stop()
		next_indicator.frame = 0
		next_indicator.visible = true
		next_indicator.play()
		next_indicator_label.visible = true
		tween_object(next_indicator_label, "modulate:a", 1.0, .1, Tween.TRANS_SINE, Tween.EASE_IN)
	
	label.visible = true
	tween_object(label, "modulate:a", 1.0, .2, Tween.TRANS_SINE, Tween.EASE_IN)


func deactivate_tween_interact(interact_parent : MarginContainer) -> void:
	var label_margin = interact_parent.get_child(1)
	var label = label_margin.get_child(0)
	next_indicator.visible = false
	label_margin.custom_minimum_size.x = temp_size
	label.visible = false
	#tween size to 0
	tween_object(label_margin, "custom_minimum_size:x", 0.0, .3, Tween.TRANS_SINE, Tween.EASE_OUT)
	await get_tree().create_timer(.15).timeout
	await tween_object(interact_parent, "modulate:a", 0.0, .1, Tween.TRANS_SINE, Tween.EASE_IN)
	interact_parent.visible = false


## TODO suspect this needs a better name
func immediate_interact_false(interact_parent : MarginContainer) -> void:
	var label_margin = interact_parent.get_child(1)
	var label = label_margin.get_child(0)
	label_margin.custom_minimum_size.x = 0.0
	next_indicator.visible = false
	interact_parent.visible = false
	label.visible = false


func tween_vignette_switch(flag : bool) -> void:
	if flag:
		dialogue_vignette.modulate.a = 0.0
		dialogue_vignette.visible = true
		await tween_object(dialogue_vignette, "modulate:a", 1.0, .5, Tween.TRANS_SINE, Tween.EASE_IN)
	else:
		dialogue_vignette.modulate.a = 1.0
		await tween_object(dialogue_vignette, "modulate:a", 0.0, .5, Tween.TRANS_SINE, Tween.EASE_IN)
		dialogue_vignette.visible = false
