extends Node3D

@onready var sub_viewport: SubViewport = %SubViewport



const lines: Array[String] = [
	"press F to pay respects",
	"blah blah blah"
]

func interact() -> void:
	DialogueManager.start_dialogue(sub_viewport, lines)
