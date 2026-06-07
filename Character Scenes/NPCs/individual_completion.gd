extends Node3D
@onready var shadow: Node3D = $"individuated individual2"

func on_completion():
	if QuestManager.has_completed(QuestManager.CharacterName.INDIVIDUAL):
		shadow.visible = true
