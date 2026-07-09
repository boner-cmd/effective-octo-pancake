extends Node3D
@onready var cube1: MeshInstance3D = $Cube_001
@onready var cube2: MeshInstance3D = $Cube_002
@onready var cylinder: MeshInstance3D = $Cylinder
@onready var cylinder_001: MeshInstance3D = $Cylinder_001

signal completion

func on_completion():
	await get_tree().create_timer(.5).timeout
	if QuestManager.has_completed(QuestManager.CharacterName.DEER):
		cube1.visible = false
		cube2.visible = false
		cylinder.visible = true
		cylinder_001.visible = true
		completion.emit()


func _ready() -> void:
	on_completion()
