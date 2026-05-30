extends Area3D

var player: CharacterBody3D
var HUD_Overlay : CanvasLayer = DialogueManager.hud_overlay

# Tracks the current object the player is overlapping with
var current_npc : Area3D = null
var current_door : Area3D = null
var current_exit : Area3D = null

signal exit_area_entered(lock : bool)
signal exit_area_exited()
signal npc_entered()
signal npc_exited()



var interacted : bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and not interacted:
		interacted = true
		if current_exit:
			await current_exit.get_parent().interact()
		elif current_npc:
			await current_npc.interact()
		interacted = false
		

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	HUD_Overlay = player.get_parent().get_child(0)

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("Door_Spawn"):
		var door = area.get_parent()
		door._set_door_anim(door.AnimStates.SPAWN)
		current_door = area
	elif area.is_in_group("Exit_Door"):
		current_exit = area
		var door = area.get_parent().door_locked
		exit_area_entered.emit(door)
	else:

		
		current_npc = area
		npc_entered.emit()
		player.temp_npc = area


func _on_area_exited(area: Area3D) -> void:
	if area.is_in_group("Door_Spawn"):
		var door = area.get_parent()
		door._set_door_anim(door.AnimStates.DESPAWN)
		current_door = null
	elif area.is_in_group("Exit_Door"):
		current_exit = null
		exit_area_exited.emit()
	else:
		current_npc = null
		npc_exited.emit()
