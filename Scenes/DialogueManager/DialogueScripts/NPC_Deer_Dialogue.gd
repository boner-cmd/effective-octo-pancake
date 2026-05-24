extends MeshInstance3D
@export var current_state : DialogueManager.CONV_STATE = DialogueManager.CONV_STATE.PLAYER_LISTEN
@export var NPC_Normal_Template_Check : bool = true

#Dialogue goes here, 100 char per string limit, strongly suggest breaking it up if it can be
#no-eye'd deer dialogue
@export var initial_lines: Array[String] = [
	"H-Hello??? Is someone there??? Someone's there, right?.",
	"Sorry, I startle easilly. Doesn't help that I can't see.",
	"You don't sound very scary... I think.",
	"You're lucky.",
	"People tell me I'm a little freaky-looking. Guess I have to take their word.",
	"I hate being scared. I freeze up like I'm caught in headlights...",
	"...Or what I imagine headlights to look like.",
	"Even if I'll never see, I'd like to at least be a little less disturbing.",
	"I know this sounds weird, but could you bring me some, uh... Eyes?",
]

@export var give_lines: Array[String] = [
	"Oh he-WOAH! Okay, you're just touching my eye sockets like that.",
	"Could have used some warning, but whatever.",
	"So I guess you found something that could cover my gaping eyeholes?",
	"That's very kind of you. Does it look good?",
	"...Is that a \"yes?\"",
]

@export var receive_lines: Array[String] = [
	"Well, I hope this works out.", 
	"I really appreciate what you've done for me and I want to give you something.",
	"Here, have this. What is it?",
	"No idea.",
]

@export var post_lines: Array[String] = [
	"No idea.",
]

@export var easter_lines: Array[String] = [
	"Still no idea.",
]
