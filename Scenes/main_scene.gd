extends Node3D

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

func change_planets(planet_id : String) -> void:
	last_planet_lookup = planet_nodes.get(planet_id)
	get_tree().root.add_child(last_planet_lookup)
	get_tree().root.remove_child(current_scene)
	current_scene = last_planet_lookup

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
