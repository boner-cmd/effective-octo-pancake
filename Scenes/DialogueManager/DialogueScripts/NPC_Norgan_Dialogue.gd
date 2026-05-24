extends MeshInstance3D
@export var current_state : DialogueManager.CONV_STATE = DialogueManager.CONV_STATE.PLAYER_LISTEN
@export var NPC_Normal_Template_Check : bool = true


@export var initial_lines: Array[String] = [
	"A thousand plateus to you, nomad.",
	"I am a featureless surface: one who has experienced a becoming of pure intensity.",
	"Through destratification, I have entered into new kinds of relationships:",
	"Ways of being that instrumental language cannot yet describe.",
	"Yet perhaps I am a bit lonely.",
	"Others seem to have difficulty working out what I'm trying to say.",
	"Maybe if I DID have some organs, it would make me a little more relateable?",
]

@export var give_lines: Array[String] = [
	"Oh cool, some organs.",
	"Alright, guess I'm a body with some organs now?",
	"Maybe I can try getting some writing published.",
]

@export var receive_lines: Array[String] = [
	"I'm trying to focus on scouring my tomes. You can leave now.",
	"I'm sure someone else could use your help.",
]

@export var post_lines: Array[String] = [
	"I'm still working on my research.",
]

@export var easter_lines: Array[String] = [
	"Do you want to hear my writing so far?",
	"On second thought, it might be a little over your head, so-to-speak.",
	"What's your deal, anyway?",
	"Maybe YOU were the real body without organs all along.",
	"...No, that doesn't have legs...",
	"Wait, are legs an organ?",
	"I think I need a study break.",
]
