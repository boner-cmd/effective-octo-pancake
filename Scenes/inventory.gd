extends MarginContainer

var selected_planet_id : String
var current_scene : Node3D
var last_planet_lookup : Node3D

var planet_nodes = {
	_1 = preload("res://Scenes/Planets/planet_test_1.tscn").instantiate(),
	_2 = preload("res://Scenes/Planets/planet_test_2.tscn").instantiate(), 
	_3 = preload("res://Scenes/Planets/planet_test_1.tscn").instantiate(), # update this
	_4 = preload("res://Scenes/Planets/planet_test_1.tscn").instantiate(), # update this
	_5 = preload("res://Scenes/Planets/planet_test_1.tscn").instantiate(), # update this
	_6 = preload("res://Scenes/Planets/planet_test_1.tscn").instantiate(), # update this
	_7 = preload("res://Scenes/Planets/planet_test_1.tscn").instantiate(), # update this
	_8 = preload("res://Scenes/Planets/planet_test_1.tscn").instantiate(), # update this
	_9 = preload("res://Scenes/Planets/planet_test_1.tscn").instantiate(), # update this
	_10 = preload("res://Scenes/Planets/planet_test_1.tscn").instantiate(), # update this
	_11 = preload("res://Scenes/Planets/planet_test_1.tscn").instantiate(), # update this
	_12 = preload("res://Scenes/Planets/planet_test_1.tscn").instantiate(), # update this
	_13 = preload("res://Scenes/Planets/planet_test_1.tscn").instantiate(), # update this
	_14 = preload("res://Scenes/Planets/planet_test_1.tscn").instantiate(), # update this
	_15 = preload("res://Scenes/Planets/planet_test_1.tscn").instantiate(), # update this
	_16 = preload("res://Scenes/Planets/planet_test_1.tscn").instantiate(), # update this
	_17 = preload("res://Scenes/Planets/planet_test_1.tscn").instantiate(), # update this
	_18 = preload("res://Scenes/Planets/planet_test_1.tscn").instantiate(), # update this
	_19 = preload("res://Scenes/Planets/planet_test_1.tscn").instantiate(), # update this
	_20 = preload("res://Scenes/Planets/planet_test_1.tscn").instantiate(), # update this
}

func change_planets() -> void:
	visible = false
	print("DEBUG: FLYING TO PLANET ID " + selected_planet_id)
	last_planet_lookup = planet_nodes.get(selected_planet_id)
	get_tree().root.add_child(last_planet_lookup)
	get_tree().root.remove_child(current_scene)
	current_scene = last_planet_lookup

func _ready() -> void:
	visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_map"):
		visible = !visible

func _on_planet_pressed(signal_planet_id: String) -> void:
	selected_planet_id = signal_planet_id
	$"ConfirmationControl".visible = true
	$"ConfirmationControl".set_default_indicator_state()

func _on_visibility_changed() -> void:
	if is_visible_in_tree():
		ui_opened.emit()
	else:
		ui_closed.emit()
			
signal ui_opened()

signal ui_closed()
