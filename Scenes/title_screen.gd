extends Node

@onready var title_screen_letters: Node3D = $"Node3D/title_screen_letters"

var letter_array : Array = []
var tween_letter : Tween

@onready var new_game_button: TextureButton = $CanvasLayer/MarginContainer/ColumnLayout/MarginContainer/LeftColumn/NewGameButton
@onready var quit_button: TextureButton = $CanvasLayer/MarginContainer/ColumnLayout/MarginContainer/LeftColumn/QuitButton
@onready var credits: TextureButton = $CanvasLayer/MarginContainer/ColumnLayout/MarginContainer/LeftColumn/Credits


func tween_letters() -> void:
	for letter in letter_array:
		letter.rotation.y = randf_range(deg_to_rad(-5.0), deg_to_rad(5.0))


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	quit_button.pivot_offset = quit_button.size / 2.0
	new_game_button.pivot_offset = new_game_button.size / 2.0
	credits.pivot_offset = credits.size / 2.0
	
	
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
	
