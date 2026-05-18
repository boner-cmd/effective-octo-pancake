extends TextureRect

func _input(event):
	if visible:
		if event.is_action_pressed("ui_accept"):
			visible = false
			get_node(^"..").go_to_planet()
		if event.is_action_pressed("ui_cancel"):
			visible = false

func _on_yeah_button_pressed() -> void:
	visible = false
	get_node(^"..").go_to_planet()

func _on_nah_button_pressed() -> void:
	visible = false
