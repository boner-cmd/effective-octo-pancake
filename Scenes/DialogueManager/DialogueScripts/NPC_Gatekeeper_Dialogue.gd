extends MeshInstance3D
@export var current_state : DialogueManager.CONV_STATE = DialogueManager.CONV_STATE.PLAYER_LISTEN
@export var NPC_Normal_Template_Check : bool = true

#Dialogue goes here, 100 char per string limit, strongly suggest breaking it up if it can be
#gatekeeper dialogue
@export var initial_lines: Array[String] = [
	"Oh, hey, A.H. How's it going? I haven't seen you since the company party.",
	"Boss man's got you on an away mission today? Running his errands, huh?",
	"Sorry, but you know the drill: anyone who wants to get through here needs a key from the king.",
	"*His brilliance* probably forgot all about that. The less he thinks about me the better, I guess.",
	"Sucks for you though. Rules are rules, you feel me? I can't risk losing this job.",
	"Head back to the King and he'll give the key to you..",
	"...Unless he lost it...",
]

@export var give_lines: Array[String] = [
	"Ayyyyy there we go. Now stick that key in my head ,you silly little weirdo.",
]

@export var receive_lines: Array[String] = [
	"Happy trails! *scoff*",
]

@export var post_lines: Array[String] = [
	"I hope I get to close the gate soon. I'm really off-balance unlocked like this.",
]

@export var easter_lines: Array[String] = [
	"Okay, I think the King really did forget about me this time.",
	"I'm going to pass out if I stay this way.",
	"When you see him, can you PLEASE ask him if I can lock up?",
]
