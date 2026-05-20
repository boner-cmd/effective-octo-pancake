extends Node3D

@export var Canvas : CanvasLayer
@export var interact_ui : MarginContainer
@onready var CanvasLayer_in: CanvasLayer = %CanvasLayer

var lines: Array[String] = [
	"boy howdy",
	"i'm stuck in the mud",
]
















func interact() -> void:
	DialogueManager.start_dialogue(CanvasLayer_in, lines)
	
func _ready() -> void:
	Canvas = CanvasLayer_in
