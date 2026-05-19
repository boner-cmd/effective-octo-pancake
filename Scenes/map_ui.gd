extends MarginContainer

var	planet_id : int

func _ready() -> void:
	visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_map"):
		visible = !visible

func go_to_planet():
	visible = false
	print("DEBUG: FLYING TO PLANET ID " + str(planet_id))
	# go to other planet

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_planet_pressed(selected_planet_id: int) -> void:
	planet_id = selected_planet_id
	get_node(^"ConfirmationControl").visible = true
	get_node(^"ConfirmationControl").set_default_indicator_state()
