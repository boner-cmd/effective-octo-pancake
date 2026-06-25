extends Node

enum OPTIONS {NONE, SOUND, CONTROLS, CREDITS}

const MENU_BUTTON_SELECTED_CHROMAKEY = preload("uid://dryfbaibo6t1f")
const MENU_BUTTON_UNSELECTED_CROMAKEY = preload("uid://62yo4oa5rjca")
const TRANSITION_SCENE_OVERLAY = preload("uid://d15cvkowrk1yl") # transition scene overlay

var letter_array : Array = []
var tween_letter : Tween
var rot_change : float = deg_to_rad(-20.0)
var tween_letter_z : Tween
var tween_letter_x : Tween
var timer_time : float = 2.0
var current_tweens : Dictionary = {}
var current_options : OPTIONS
var transition_scene: CanvasLayer

var test : bool = false

@onready var clown_rig_fbx: Node3D = $Node3D/ClownRigFBX
@onready var title_screen_planet: MeshInstance3D = $Node3D/TitleScreenPlanet

@onready var cloud_parent: Control = $CanvasLayer/CloudParent
@onready var cloud_tweens: Array = cloud_parent.tween_array
@onready var title_screen_letters: Node3D = $"Node3D/title_screen_letters"
@onready var timer: Timer = $Node3D/Timer

@onready var continue_button: TextureButton = %ContinueButton
@onready var new_game_button: TextureButton = %NewGameButton
@onready var controls_button: TextureButton = %ControlsButton
@onready var sound_button: TextureButton = %SoundButton
@onready var options_button: TextureButton = %OptionsButton
@onready var quit_button: TextureButton = %QuitButton
@onready var credits_button: TextureButton = %CreditsButton
@onready var return_button: TextureButton = %ReturnButton

@onready var start_menu_control: Control = %StartMenuControl
@onready var options_control: Control = %OptionsControl

@onready var audio_control_v_box: VBoxContainer = %AudioControlVBox
@onready var keyboard_controls_menu: Control = %KeyboardControlsMenu
@onready var credits_control: Control = %CreditsControl

@onready var transition: ColorRect = %Transition



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SaveManager.compressed_data = FileAccess.get_file_as_bytes("user://Attentive_Helper_Data.dat")
	if FileAccess.get_open_error():
		continue_button.disabled = true
	timer.wait_time = timer_time
	letter_array = title_screen_letters.get_children()
	tween_letters()
	clown_rig_fbx._set_player_anim(clown_rig_fbx.AnimStates.WALK)
	_set_initial()
	


func _process(delta: float) -> void:
	title_screen_planet.rotation_degrees.x -= delta * 15.0
	
	if title_screen_planet.rotation_degrees.x < -360.0:
		title_screen_planet.rotation_degrees.x = 0.0


func tween_letters() -> void:
	for letter in letter_array:
		letter.rotation.z = rot_change
		tween_letter_z = get_tree().create_tween()
		tween_letter_z.tween_property(letter, "rotation:z", rot_change * -1, timer_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween_letter_x = get_tree().create_tween()
		tween_letter_x.tween_property(letter, "rotation:x", rot_change * -1, timer_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).set_delay(timer_time/2.0)
		tween_letter_z.play()
		tween_letter_x.play()


func kill_tweens() -> void:
	for tween in cloud_tweens:
		tween.kill()
	tween_letter_x.kill()
	tween_letter_z.kill()


func _set_initial() -> void: #set pivots, materials, etc
	for button in get_tree().get_nodes_in_group("Start_Menu_Buttons"):
		button.pivot_offset_ratio = Vector2(.5,.5)
		button.mouse_entered.connect(_on_mouse_entered_or_focus, CONNECT_APPEND_SOURCE_OBJECT)
		button.focus_entered.connect(_on_mouse_entered_or_focus, CONNECT_APPEND_SOURCE_OBJECT)
		button.mouse_exited.connect(_on_mouse_exited_or_unfocus, CONNECT_APPEND_SOURCE_OBJECT)
		button.focus_exited.connect(_on_mouse_exited_or_unfocus, CONNECT_APPEND_SOURCE_OBJECT)
	continue_button.pressed.connect(_on_continue_button_pressed)
	new_game_button.pressed.connect(_on_new_game_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	options_button.pressed.connect(_on_options_button_pressed)
	return_button.pressed.connect(_on_return_button_pressed)
	controls_button.pressed.connect(_on_options_item_pressed.bind(keyboard_controls_menu, OPTIONS.CONTROLS, controls_button))
	sound_button.pressed.connect(_on_options_item_pressed.bind(audio_control_v_box, OPTIONS.SOUND, sound_button))
	credits_button.pressed.connect(_on_options_item_pressed.bind(credits_control, OPTIONS.CREDITS, credits_button))
	
	current_options = OPTIONS.NONE
	
	start_menu_control.modulate.a = 0.0
	options_control.modulate.a = 0.0
	options_control.visible = false
	transition.visible = true
	audio_control_v_box.modulate.a = 0.0
	keyboard_controls_menu.modulate.a = 0.0
	credits_control.modulate.a = 0.0
	
	controls_button.disabled = true
	sound_button.disabled = true
	credits_button.disabled = true
	return_button.disabled = true
	for Canvas in get_tree().root.get_children():
		if Canvas.name == &"TransitionSceneOverlay":
			Canvas.queue_free()
	await tween_object(transition, "modulate:a", 0.0, .6, Tween.TRANS_SINE, Tween.EASE_OUT)
	transition.visible = false
	tween_object(start_menu_control, "modulate:a", 1.0, 1.0, Tween.TRANS_SINE, Tween.EASE_IN)
	##TODO set the 


func tween_object(object : Object, property : NodePath, goal : Variant, time : float, 
			transtype : Tween.TransitionType, easetype : Tween.EaseType) -> void:
	
	if object.is_in_group("Current_Tweened_Objects"):
		current_tweens[object].kill()
		current_tweens.erase(object)
		object.remove_from_group("Current_Tweened_Objects")
	
	object.add_to_group("Current_Tweened_Objects")
	var tweened_object = get_tree().create_tween()
	tweened_object.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	current_tweens[object] = tweened_object
	var tweener_object = tweened_object.tween_property(object, property, goal, time).from_current()
	tweener_object.set_trans(transtype).set_ease(easetype)
	tweened_object.play()
	await tweened_object.finished
	current_tweens.erase(object)
	object.remove_from_group("Current_Tweened_Objects")
	if tweened_object and tweened_object.is_valid():
		tweened_object.kill()


func transition_sequence() -> void:
	tween_object(start_menu_control, "modulate:a", 0.0, .5, Tween.TRANS_SINE, Tween.EASE_IN)
	transition.visible = true
	await tween_object(transition, "modulate:a", 1.0, .5, Tween.TRANS_SINE, Tween.EASE_IN)
	transition_scene = TRANSITION_SCENE_OVERLAY.instantiate()
	get_tree().root.add_child(transition_scene)
	transition_scene.request_ready()


func _on_continue_button_pressed() -> void:
	SaveManager.trigger_load = true
	_on_new_game_button_pressed()


func _on_new_game_button_pressed() -> void:
	new_game_button.disabled = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	await transition_sequence()
	kill_tweens()
	SaveManager.check_load()


func _on_options_button_pressed() -> void:
	current_options = OPTIONS.NONE
	continue_button.disabled = true
	new_game_button.disabled = true
	options_button.disabled = true
	quit_button.disabled = true
	
	options_control.visible = true
	tween_object(start_menu_control, "modulate:a", 0.0, .5, Tween.TRANS_SINE, Tween.EASE_OUT)
	await tween_object(options_control, "modulate:a", 1.0, .5, Tween.TRANS_SINE, Tween.EASE_IN)
	start_menu_control.visible = false
	
	controls_button.disabled = false
	sound_button.disabled = false
	credits_button.disabled = false
	return_button.disabled = false

func _on_return_button_pressed() -> void:
	handle_options()
	current_options = OPTIONS.NONE
	controls_button.disabled = true
	sound_button.disabled = true
	credits_button.disabled = true
	return_button.disabled = true
	
	start_menu_control.visible = true
	tween_object(options_control, "modulate:a", 0.0, .5, Tween.TRANS_SINE, Tween.EASE_OUT)
	await tween_object(start_menu_control, "modulate:a", 1.0, .5, Tween.TRANS_SINE, Tween.EASE_IN)
	options_control.visible = false
	
	continue_button.disabled = false
	new_game_button.disabled = false
	options_button.disabled = false
	quit_button.disabled = false


func _on_options_item_pressed(tweened_object : Object, options_enum : OPTIONS, button : TextureButton) -> void:
	handle_options()
	if current_options != options_enum:
		button.texture_normal = MENU_BUTTON_SELECTED_CHROMAKEY
		tween_object(tweened_object, "modulate:a", 1.0, .5, Tween.TRANS_SINE, Tween.EASE_IN)
		current_options = options_enum
	else:
		button.texture_normal = MENU_BUTTON_UNSELECTED_CROMAKEY
		current_options = OPTIONS.NONE


func handle_options() -> void:
	match current_options: #hide last thing
		OPTIONS.SOUND:
			tween_object(audio_control_v_box, "modulate:a", 0.0, .5, Tween.TRANS_SINE, Tween.EASE_OUT)
			sound_button.texture_normal = MENU_BUTTON_UNSELECTED_CROMAKEY
		OPTIONS.CONTROLS:
			tween_object(keyboard_controls_menu, "modulate:a", 0.0, .5, Tween.TRANS_SINE, Tween.EASE_OUT)
			controls_button.texture_normal = MENU_BUTTON_UNSELECTED_CROMAKEY
		OPTIONS.CREDITS:
			tween_object(credits_control, "modulate:a", 0.0, .5, Tween.TRANS_SINE, Tween.EASE_OUT)
			credits_button.texture_normal = MENU_BUTTON_UNSELECTED_CROMAKEY
		_:
			pass


func _on_quit_button_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	kill_tweens()
	get_tree().quit()


func _on_timer_timeout() -> void:
	rot_change = rot_change * -1
	tween_letters()


func _on_mouse_entered_or_focus(button) -> void:
	AudioManager.sfx_play(AudioManager.sfx_blip)
	button.scale = Vector2(1.1, 1.1)
	##TODO these ifs are for the overlay animations for the options panel
	if button.name == &"ControlsButton":
		pass
	elif button.name == &"SoundButton":
		pass
	elif button.name == &"CreditsButton":
		pass
	elif button.name == &"ReturnButton":
		pass


func _on_mouse_exited_or_unfocus(button) -> void:
	button.scale = Vector2(1.0, 1.0)
