extends MeshInstance3D
@export var current_state : DialogueManager.CONV_STATE = DialogueManager.CONV_STATE.PLAYER_LISTEN
@export var NPC_Normal_Template_Check : bool = true

#Dialogue goes here, 100 char per string limit, strongly suggest breaking it up if it can be
#lamp dialogue
@export var initial_lines: Array[String] = [
	"(A lamp with no lightbulb)",
]

@export var give_lines: Array[String] = [
	"(With some effort, you manage to screw in the lightbulb with your clumsy little stick arms.)",
	"(Your simple homonculoid consciousness briefly toys with the vaguest idea of making a joke:",
	"Something along the lines of \"how many attentive helpers does it take to screw in a lightbulb\"",
	"But collapses under the strain before the notion can breach the membrane of basic abstraction.)",
	"(Triumphantly, still, the answer is one.)",
]

@export var receive_lines: Array[String] = [
	"(The light casts a long shadow behind you, both physically and psychologically.)",
	"(There is just enough space in your feeble mind to fit something *other* than yourself,",
	"Yet simultaneously somehow *un-other* than yourself.)",
	"(You are nonetheless fundamentally incapable of perceiving even the faintest sliver of this fact,)",
	"(And some might say are all the more blessed thus.)",
]

@export var post_lines: Array[String] = [
	"(You pause briefly but sincerely in solidarity with the inanimate lamp.)",
	"(You are able to register the sensation of its soft, warm light.)",
	"(No value judgement. Not good, not bad: just there.)",
]

@export var easter_lines: Array[String] = [
	"(Hello again,)",
	"(Friend.)",
]
