extends Node

@onready var title_screen_letters: Node3D = $"Node3D/title_screen_letters"

var letter_array : Array = []
var tween_letter : Tween



func tween_letters() -> void:
	for letter in letter_array:
		tween_letter = get_tree().create_tween()
		tween_letter.tween_property(letter, "rotation:y", randf_range(deg_to_rad(-20), deg_to_rad(20)), randf_range(2.0, 4.0))
		tween_letter.set_ease(Tween.EASE_IN_OUT)
		tween_letter.set_trans(Tween.TRANS_SINE)
		tween_letter.set_parallel(true)
		tween_letter.play()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	letter_array = title_screen_letters.get_children()
	tween_letters()
	


func _on_new_game_button_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().change_scene_to_file('res://Scenes/MainScene.tscn')


func _on_quit_button_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()


func _on_timer_timeout() -> void:
	tween_letters()


func _on_new_game_button_focus_entered() -> void:
	AudioManager.sfx_play(AudioManager.sfx_honk)


func _on_new_game_button_mouse_entered() -> void:
	AudioManager.sfx_play(AudioManager.sfx_blip)
