extends MeshInstance3D
@export var current_state : DialogueManager.CONV_STATE = DialogueManager.CONV_STATE.PLAYER_LISTEN
@export var NPC_Normal_Template_Check : bool = true

#Dialogue goes here, 100 char per string limit, strongly suggest breaking it up if it can be
@export var initial_lines: Array[String] = [
	"Howdy there, fella!",
	"I'm just your average, fun-loving, run-of-the-mill kind of guy.",
	"Yesiree.",
]

@export var give_lines: Array[String] = [

#I don't think anything should go here

]

@export var receive_lines: Array[String] = [
	"Say, fella. I'm not one to comeplain, but I got a problem on my hands.",
	"They say you can't have too much of a good thing, and in most cases, they'd be right.",
	"But you see, the thing is I've got too many organs.",
	"I'm chock FULL of 'em!",
	"I know, I know, my steak too juicy. My lobster too buttery.",
	"You wouldn't be able to take some of these here organs of my hands, would you?",
	"Make sure they find their way into good egg--",
	"I mean--",
	"Hands.",
	"No scamper along now, ya hear?",
]

@export var post_lines: Array[String] = [
	"Feels good to have that weight off my chest.",
	"Literally!",
]

@export var easter_lines: Array[String] = [
	"Funny running into you here.",
	"Didya miss seeing my pretty face? HAHA!",
]
