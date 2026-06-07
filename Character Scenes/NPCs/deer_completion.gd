extends Node3D
@onready var cube1: MeshInstance3D = $Cube_001
@onready var cube2: MeshInstance3D = $Cube_002
@onready var cylinder: MeshInstance3D = $Cylinder
@onready var cylinder_001: MeshInstance3D = $Cylinder_001
@onready var cubed_skybox: Node3D = $"../../../CubedSkybox"
@onready var cubed_skybox_2: Node3D = $"../../../CubedSkybox2"

func on_completion():
	if QuestManager.has_completed(QuestManager.CharacterName.DEER):
		cube1.visible = false
		cube2.visible = false
		cylinder.visible = true
		cylinder_001.visible = true
		cubed_skybox.visible = false
		cubed_skybox_2.visible = true
