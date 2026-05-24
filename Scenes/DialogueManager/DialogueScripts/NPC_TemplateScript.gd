extends MeshInstance3D
@export var current_state : DialogueManager.CONV_STATE = DialogueManager.CONV_STATE.PLAYER_LISTEN
@export var NPC_Normal_Template_Check : bool = true

#Dialogue goes here, 100 char per string limit, strongly suggest breaking it up if it can be
@export var initial_lines: Array[String] = [
	"initial lines 1",
	]

@export var give_lines: Array[String] = [
	"give lines 1",
	]

@export var receive_lines: Array[String] = [
	"receive lines 1",
	]

@export var post_lines: Array[String] = [
	"post lines",
	]

@export var easter_lines: Array[String] = [
	"easter lines",
	]
