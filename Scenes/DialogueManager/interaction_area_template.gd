extends Node3D

# TODO move everything into Main and delete this script
@onready var main_planet_id : int = 0
@onready var speech_sound = AudioManager.speech_sound
var player : CharacterBody3D
var temp_rotation : Vector3
var towards_rotation : float


func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _process(delta: float) -> void:
	temp_rotation = self.rotation
	self.look_at(player.global_position)
	towards_rotation = self.rotation.y
	self.rotation = temp_rotation
	self.rotation.y = lerp_angle(temp_rotation.y, towards_rotation, 2 * delta)
	

#this should only run if child is an NPC
func interact() -> void:
	
	
	var current_status : DialogueManager.CONV_STATE = DialogueManager.dialogue_state
	if current_status == DialogueManager.CONV_STATE.FINISHED:
		main_planet_id = get_tree().root.get_child(5).current_planet_id
		print("main_planet_ID = ",	main_planet_id)
		DialogueManager.start_dialogue(DialogueManager.hud_overlay, main_planet_id, speech_sound)
		
		for NPC in get_children():
			if NPC.is_in_group("Completion_Change"):
				DialogueManager.planet_state_change.connect(NPC.on_completion)
