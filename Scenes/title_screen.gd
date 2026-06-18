extends Node

var letter_array : Array = []
var tween_letter : Tween
var rot_change : float = deg_to_rad(-20.0)
var tween_letter_z : Tween
var tween_letter_x : Tween
var timer_time : float = 2.0

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





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = timer_time
	letter_array = title_screen_letters.get_children()
	tween_letters()
	clown_rig_fbx._set_player_anim(clown_rig_fbx.AnimStates.WALK)
	_set_buttons()


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


func _set_buttons() -> void: #set pivots, materials, etc
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

func _on_continue_button_pressed() -> void:
	pass


func _on_new_game_button_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	kill_tweens()
	get_tree().change_scene_to_file('res://Scenes/MainScene.tscn')


func _on_options_button_pressed() -> void:
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


func _on_mouse_exited_or_unfocus(button) -> void:
	button.scale = Vector2(1.0, 1.0)
	
