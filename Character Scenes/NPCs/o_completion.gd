extends Node3D
@onready var q: Node3D = $"../q"
@onready var cubed_planet: Node3D = $"../../../Cubed_Planet"
@onready var cubed_skybox: Node3D = $"../../../CubedSkybox"
@onready var cubed_skybox_2: Node3D = $"../../../CubedSkybox2"
@onready var cubed_planet_2: Node3D = $"../../../Cubed_Planet2"

func on_completion():
	if QuestManager.has_completed(QuestManager.CharacterName.O):
		visible = false
		q.visible = true
		cubed_planet.visible = false
		cubed_skybox.visible = false
		cubed_planet_2.visible = true
		cubed_skybox_2.visible = true
