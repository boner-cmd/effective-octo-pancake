extends Node3D

func on_completion():
	if QuestManager.has_completed(QuestManager.CharacterName.INDIVIDUAL):
		for node in get_children():
			if node is MeshInstance3D:
				node.cast_shadow = true
