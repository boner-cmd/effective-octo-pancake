extends Area3D


var interact_ui : MarginContainer
# Tracks the current object the player is overlapping with
var current_area: Area3D = null
# var interaction_label: Label = null

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and current_area:
		current_area.interact()
		interact_ui.visible = false

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("Door"):
		print(area)
	else:
		current_area = area
		interact_ui = area.interact_ui
		interact_ui.visible = true

func _on_area_exited(_area: Area3D) -> void:
		current_area = null
		interact_ui.visible = false
