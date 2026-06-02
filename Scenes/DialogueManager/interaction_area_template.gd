extends Node3D

# TODO move everything into Main and delete this script
@onready var main_planet_id : int = 0
@onready var speech_sound = AudioManager.speech_sound

@onready var player_cutscene_locator: Node3D = %Player_Cutscene_Locator
@onready var _cam_frame_both: Camera3D = %frame_both
@onready var _cam_player_give: Camera3D = %player_give
@onready var _cam_frame_both_puddles: Camera3D = %frame_both_puddles
@onready var _cam_frame_both_animals: Camera3D = %frame_both_animals
@onready var _cam_player_receive: Camera3D = %player_receive

var player : CharacterBody3D
var temp_rotation : Vector3
var towards_rotation : float

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _process(_delta: float) -> void:
	self.look_at(player.global_position)
	rotation.x = 0
	rotation.z = 0
	

#this should only run if child is an NPC and should probably be moved to the player's interact script I guess
func interact() -> void:
	var current_status : DialogueManager.CONV_STATE = DialogueManager.dialogue_state
	if current_status == DialogueManager.CONV_STATE.FINISHED:
		main_planet_id = get_tree().root.get_child(5).current_planet_id
		DialogueManager.start_dialogue(DialogueManager.hud_overlay, main_planet_id, speech_sound)
		
		for NPC in get_children():
			if NPC.is_in_group("Completion_Change"):
				if !DialogueManager.planet_state_change.is_connected(NPC.on_completion):
					DialogueManager.planet_state_change.connect(NPC.on_completion)
				
	player.player_cutscene_locator = player_cutscene_locator
	player._cam_frame_both = _cam_frame_both
	player._cam_player_give = _cam_player_give
	player._cam_frame_both_puddles = _cam_frame_both_puddles
	player._cam_player_receive = _cam_player_receive
	player._cam_frame_animals = _cam_frame_both_animals
