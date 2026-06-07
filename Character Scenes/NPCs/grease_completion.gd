extends Node3D

func on_completion():
	if QuestManager.has_completed(QuestManager.CharacterName.GREASE):
		visible = false
