extends Node3D
@export var current_state : DialogueManager.CONV_STATE = DialogueManager.CONV_STATE.PLAYER_LISTEN
@export var NPC_Normal_Template_Check : bool = true

#Dialogue goes here, 100 char per string limit, strongly suggest breaking it up if it can be
#o dialogue
@export var initial_lines: Array[String] = [
	"Ohhhhhhhhhhhhhh",
	"I am the Ohhhhhhh, didn't you knoooooooooow?",
	"Noooooooooooo, nobody knooooooooooows.",
	"Noooooobody knooooooows I am Ohhhhhhhhhhh.",
	"\"A Zerooooooo?\"", 
	"\"A circooooooole?\"",
	"Noooooooooo:",
	"Ohhhhhhhhhhh.",
	"If I were not Ohhhhhhhh, as long as everybody knoooooooooows,",
	"That would be oooooooooooookay.",
]

@export var give_lines: Array[String] = [
	"Ohhhhhhhhhhh? A diagonal line?",
	"I knooooooooow! I can be a Q!",
	"That's still a letter, and now people will knoooooooow--",
	"Oops, I mean,",
	"know",
	"what I am.",
	"Hoo boy, this will take some time getting qused to.",
]

@export var receive_lines: Array[String] = [
	"I's? Why would I have any I's?",
	"I have these left over O's, though.",
	"Hope they help q out!",
	"(No, that didn't work.)",
]

@export var post_lines: Array[String] = [
	"Q... Q... Q... Not a lot of words with Q in them, are there?",
]

@export var easter_lines: Array[String] = [
	"I'll tell you one thing, it's a lot quicker to talk now.",
	"No, wait! That was the perfect chance!",
]
