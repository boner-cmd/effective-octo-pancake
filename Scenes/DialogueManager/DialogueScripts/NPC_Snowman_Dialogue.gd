extends MeshInstance3D
@export var current_state : DialogueManager.CONV_STATE = DialogueManager.CONV_STATE.PLAYER_LISTEN
@export var NPC_Normal_Template_Check : bool = true

#Dialogue goes here, 100 char per string limit, strongly suggest breaking it up if it can be
#snowman dialogue
@export var initial_lines: Array[String] = [
	"BRRRRR!!! I know space is cold, but this is a bit much. Wouldn't you agree?.",
	"I'm no lightweight, either. I'm built OF cold, let alone FOR.",
]

@export var give_lines: Array[String] = [
	"A space blanket? That’s perfect!",
]

@export var receive_lines: Array[String] = [
	"I’ll trade you this carrot for it. Everyone used to have a carrot nose back in the day",
	"You can guess that breathing in the same recycled air has not been pleasant.",
	"Never quite worked for me. It just kept falling off.",
]

@export var post_lines: Array[String] = [
	"Now I could really go for some hot chocolate. Just kidding! I'd die.",
]

@export var easter_lines: Array[String] = [
	"Y’know, I ended up getting used to the cold. I still have the space blanket, though.",
	"I’ve been thinking of using it for a picnic. Actually, would you be interested?",
	"Do you even eat? Yeah, me neither. Guess we’d better not…",
]
