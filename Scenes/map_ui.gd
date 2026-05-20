extends MarginContainer

var selected_planet_id : String

func _ready() -> void:
	visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_map"):
		visible = !visible

func go_to_planet():
	visible = false
	print("DEBUG: FLYING TO PLANET ID " + str(selected_planet_id))
	get_tree().change_scene_to_file('res://Scenes/MainScene.tscn')
	# go to other planet

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_planet_pressed(signal_planet_id: String) -> void:
	selected_planet_id = signal_planet_id
	$"ConfirmationControl".visible = true
	$"ConfirmationControl".set_default_indicator_state()
