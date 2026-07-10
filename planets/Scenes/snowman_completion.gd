extends Node3D
@onready var space_blanket_mesh: MeshInstance3D = $SpaceBlanketMesh


func on_completion():
	await get_tree().create_timer(.1).timeout
	if QuestManager.has_completed(QuestManager.CharacterName.SNOWMAN):
		space_blanket_mesh.visible = true


func _ready() -> void:
	on_completion()
