extends Node

@onready var title_screen_letters: Node3D = $"Node3D/title_screen_letters"
@onready var timer: Timer = $Node3D/Timer
var letter_array : Array = []
var tween_letter : Tween
var rot_change : float = deg_to_rad(-20.0)
var tween_letter_z : Tween
var tween_letter_x : Tween
var timer_time : float = 2.0
@onready var bg_container_largeStar: MarginContainer = $"CanvasLayer/BG_Container 2"
@onready var bg_container_smallStar: MarginContainer = $"CanvasLayer/BG_Container 3"
@onready var bg_container_largeShadow: MarginContainer = $"CanvasLayer/BG_Container 4"
@onready var bg_container_smallShadow: MarginContainer = $"CanvasLayer/BG_Container 5"

@onready var new_game_button: TextureButton = $CanvasLayer/MarginContainer/ColumnLayout/MarginContainer/LeftColumn/NewGameButton
@onready var quit_button: TextureButton = $CanvasLayer/MarginContainer/ColumnLayout/MarginContainer/LeftColumn/QuitButton
@onready var credits: TextureButton = $CanvasLayer/MarginContainer/ColumnLayout/MarginContainer/LeftColumn/Credits

func tween_letters() -> void:
	for letter in letter_array:
		letter.rotation.z = rot_change
		tween_letter_z = get_tree().create_tween()
		tween_letter_z.tween_property(letter, "rotation:z", rot_change * -1, timer_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween_letter_x = get_tree().create_tween()
		tween_letter_x.tween_property(letter, "rotation:x", rot_change * -1, timer_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).set_delay(timer_time/2.0)
		tween_letter_z.play()
		tween_letter_x.play()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = timer_time
	quit_button.pivot_offset = quit_button.size / 2.0
	new_game_button.pivot_offset = new_game_button.size / 2.0
	credits.pivot_offset = credits.size / 2.0
	letter_array = title_screen_letters.get_children()
	tween_letters()

func _process(delta: float) -> void:
	bg_container_largeStar.rotation_degrees += delta * .3
	bg_container_largeShadow.rotation_degrees = bg_container_largeStar.rotation_degrees
	
	bg_container_smallStar.rotation_degrees += delta * .1
	bg_container_smallShadow.rotation_degrees = bg_container_smallStar.rotation_degrees
	
	if bg_container_largeStar.rotation_degrees > 360.0:
		bg_container_largeStar.rotation_degrees = 0.0
	if bg_container_smallStar.rotation_degrees > 360.0:
		bg_container_smallStar.rotation_degrees = 0.0

func _on_new_game_button_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().change_scene_to_file('res://Scenes/MainScene.tscn')

func _on_quit_button_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

func _on_timer_timeout() -> void:
	rot_change = rot_change * -1
	tween_letters()

func _on_new_game_button_focus_entered() -> void:
	AudioManager.sfx_play(AudioManager.sfx_honk)
	tween_letter_x.kill()
	tween_letter_z.kill()

func _on_new_game_button_mouse_entered() -> void:
	AudioManager.sfx_play(AudioManager.sfx_blip)
	new_game_button.scale = Vector2(1.2, 1.2)

func _on_new_game_button_mouse_exited() -> void:
	new_game_button.scale = Vector2(1.0, 1.0)

func _on_quit_button_focus_entered() -> void:
	AudioManager.sfx_play(AudioManager.sfx_honk)

func _on_quit_button_mouse_entered() -> void:
	AudioManager.sfx_play(AudioManager.sfx_blip)
	quit_button.scale = Vector2(1.2, 1.2)

func _on_quit_button_mouse_exited() -> void:
	quit_button.scale = Vector2(1.0, 1.0)

func _on_credits_focus_entered() -> void:
	AudioManager.sfx_play(AudioManager.sfx_honk)

func _on_credits_mouse_entered() -> void:
	AudioManager.sfx_play(AudioManager.sfx_blip)
	credits.scale = Vector2(1.2, 1.2)

func _on_credits_mouse_exited() -> void:
	credits.scale = Vector2(1.0, 1.0)
	
