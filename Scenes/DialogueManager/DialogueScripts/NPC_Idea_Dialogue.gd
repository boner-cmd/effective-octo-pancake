extends MeshInstance3D
@export var current_state : DialogueManager.CONV_STATE = DialogueManager.CONV_STATE.PLAYER_LISTEN
@export var NPC_Normal_Template_Check : bool = true

#Dialogue goes here, 100 char per string limit, strongly suggest breaking it up if it can be
#idea guy dialogue
@export var initial_lines: Array[String] = [
	"Oooh, yes! Another brrrrrrillliant one! I've GOT to write that down, as I always do.",
	"You see, ideas flow out of me effortlessly, like shi--WAIT, that's it!",
	"Oh that one's marvelous! As always, of course.",
	"What was I talking about? Something about a goose?",
	"It doesn't matter.",
	"Because I can feel a fresh, hot idea sliding it's way up my brainstem.",
	"Poised and ready to shoot forth from my turgid neocortex, out unto a needy and waiting world!",
	"You might want to move out of the way if you don't want to get caught in the splash zone.",
	"Then again, who wouldn't?",
	"My ideas are a priceless commodity.",
	"No, I sully my ideas by refering to them as such.",
	"My ideas are a gift from God himself,",
	"And I am his chosen vessel through which divine truth spouts.",
]

@export var give_lines: Array[String] = [
	"What's this?",
	"GASP",
	"Oh, that's it! That's it right there!",
	"I think I'm-",
	"I'm gonna-",
	"Oh God!",
	"EEEEEEEEEUUUUUUUURRREEEEEEEEEEEEEEEEEEEKAAAAAAAAAA!!!!!!!!!",
]

@export var receive_lines: Array[String] = [
	"*Pant* *pant* *pant*",
	"Wheeeeeeeew",
	"That was a BIG one.",
	"I ideated soooo haaard.",
	"I haven't thought like that in ages.",
	"Was it as good for you as it was for me?",
	"Only joking. Of course it was.",
	"There's some change for a cab on the nightstand, next to the lamp.",
	"(You look around and don't see anything like that here.)",
]

@export var post_lines: Array[String] = [
	"(Seems like he's fast asleep, standing up, with his eyes open.)",
]

@export var easter_lines: Array[String] = [
	"I've been thinking about you a lot lately.",
	"Which isn't to say I don't about everything a lot.",
	"Why haven't you returned my calls?",
]
