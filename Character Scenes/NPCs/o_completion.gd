extends Node3D
@onready var q: Node3D = $"../q"
@onready var cubed_planet: Node3D = $"../../../Cubed_Planet"
@onready var cubed_skybox: Node3D = $"../../../CubedSkybox"
const Q_PLANET = preload("uid://dk8lja3wpiagu")
const Q_SKYBOX = preload("uid://qgwupr3ubecg")

func on_completion():
	visible = false
	q.visible = true
	cubed_planet.cubed_planet.material_override = Q_PLANET
	cubed_skybox.cubed_skybox.material_override = Q_SKYBOX
