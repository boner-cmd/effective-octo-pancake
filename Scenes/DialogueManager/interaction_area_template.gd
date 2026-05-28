extends Node3D

# TODO move everything into Main and delete this script
@onready var interact_ui : MarginContainer = %interact
@onready var CanvasLayer_in : CanvasLayer = %CanvasLayer
@onready var main_planet_id : int = get_tree().root.get_child(2).current_planet_id
@onready var speech_sound = preload("res://sound fx exports/typewriter2026-05-20_13_26_04.wav")

#this should only run if child is an NPC
func interact() -> void:
	var current_status : DialogueManager.CONV_STATE = DialogueManager.dialogue_state
	if current_status == DialogueManager.CONV_STATE.FINISHED:
		main_planet_id = get_tree().root.get_child(2).current_planet_id
		DialogueManager.start_dialogue(CanvasLayer_in, main_planet_id, speech_sound)
		
		for NPC in get_children():
			if NPC.is_in_group("Completion_Change"):
				DialogueManager.planet_state_change.connect(NPC.on_completion)
