extends TextureRect

var	planet_id : int

func go_to_planet():
	visible = false
	print("DEBUG: FLYING TO PLANET ID " + str(planet_id))
	# go to other planet

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_planet_pressed(selected_planet_id: int) -> void:
	planet_id = selected_planet_id
	get_node(^"ConfirmationDialog").visible = true
