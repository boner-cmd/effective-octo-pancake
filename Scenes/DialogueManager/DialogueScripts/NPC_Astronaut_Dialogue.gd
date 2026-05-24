extends MeshInstance3D
@export var current_state : DialogueManager.CONV_STATE = DialogueManager.CONV_STATE.PLAYER_LISTEN
@export var NPC_Normal_Template_Check : bool = true

#Dialogue goes here, 100 char per string limit, strongly suggest breaking it up if it can be
@export var initial_lines: Array[String] = [
	"Mayday! Mayday! Houston, we have a problem: I'm running dangerously low on oxygen.",
	"Everyone seems to think they can just breathe in space on their own with no helmet!",
	"Well, I don't believe it, so it's not true.",
]

@export var give_lines: Array[String] = [
	"Oxygen? Oh, sweet oxygen! You're a REAL lifesaver.",
]

@export var receive_lines: Array[String] = [
	"Take this space blanket. I don't need it. It's incredibly hot inside my spacesuit.",
	"You can guess that breathing in the same recycled air has not been pleasant.",
	"And you'd be right about it too.",
]

@export var post_lines: Array[String] = [
	"Sooo much better",
]

@export var easter_lines: Array[String] = [
	"Alright, now it's musty in here again.",
]
