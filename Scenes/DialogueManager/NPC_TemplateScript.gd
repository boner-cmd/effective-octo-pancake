extends MeshInstance3D

@export var current_state : DialogueManager.CONV_STATE = DialogueManager.CONV_STATE.PLAYER_LISTEN

@export var NPC_Normal_Template_Check : bool = true




#Dialogue goes here
@export var initial_lines: Array[String] = [
	"initial lines 1",
	"initial lines 2",
	"initial lines 3",
	]

@export var give_lines: Array[String] = [
	"give lines 1",
	"give lines 2",
	"give lines 3",
	]

@export var receive_lines: Array[String] = [
	"receive lines 1",
	"receive lines 2",
	"receive lines 3",
	]

@export var post_lines: Array[String] = [
	"post lines",
	]

@export var easter_lines: Array[String] = [
	"easter lines",
	]
