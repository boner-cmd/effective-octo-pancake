extends Node3D


func on_completion():
	await get_tree().create_timer(.5).timeout
	if QuestManager.has_completed(QuestManager.CharacterName.INDIVIDUAL):
		for node in get_children():
			if node is MeshInstance3D:
				node.cast_shadow = true


func _ready() -> void:
	on_completion()
