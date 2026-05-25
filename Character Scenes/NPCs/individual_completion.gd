extends Node3D
@onready var shadow: Node3D = $"individuated individual2"

func on_completion():
	shadow.visible = true
