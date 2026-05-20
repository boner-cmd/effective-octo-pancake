extends Node3D

@onready var CanvasLayer_in: CanvasLayer = %CanvasLayer



const lines: Array[String] = [
	"press F to pay respects",
	"blah blah blah"
]

func interact() -> void:
	DialogueManager.start_dialogue(CanvasLayer_in, lines)
