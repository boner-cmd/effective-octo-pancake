extends Area3D
var player: CharacterBody3D

var interact_ui : MarginContainer

# Tracks the current object the player is overlapping with
var current_npc: Area3D = null
var current_door: Area3D = null
var current_exit: Area3D = null
# var interaction_label: Label = null

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and current_npc:
		current_npc.interact()
		interact_ui.visible = false
		
	#initiate exit animation
	if event.is_action_pressed("interact") and current_exit:
		var exit
		exit = current_exit.get_parent()
		player = self.get_parent()
		exit.interact()

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("Door_Spawn"):
		var door = area.get_parent()
		door.spawn()
		print("DOOR")
		current_door = area
	elif area.is_in_group("Exit_Door"):
		print("EXIT")
		current_exit = area
	else:
		current_npc = area
		interact_ui = area.interact_ui
		interact_ui.visible = true

func _on_area_exited(area: Area3D) -> void:
		if area.is_in_group("Door_Spawn"):
			var door = area.get_parent()
			door.despawn()
			current_door = null
			print("DOOR")
		elif area.is_in_group("Exit_Door"):
			current_exit = null
			print("EXIT")
		else:
			current_npc = null
			interact_ui.visible = false
