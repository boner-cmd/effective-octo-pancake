extends MeshInstance3D
@export var current_state : DialogueManager.CONV_STATE = DialogueManager.CONV_STATE.PLAYER_LISTEN
@export var NPC_Normal_Template_Check : bool = true

#Dialogue goes here, 100 char per string limit, strongly suggest breaking it up if it can be
#hungry horse dialogue
@export var initial_lines: Array[String] = [
	"I'm hungry.",
]

@export var give_lines: Array[String] = [
	"Yum.",
]

@export var receive_lines: Array[String] = [
	"Here.",
]

@export var post_lines: Array[String] = [
	"I'm full.",
]

@export var easter_lines: Array[String] = [
	"I'm getting hungry again.",
]
