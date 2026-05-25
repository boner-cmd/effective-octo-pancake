extends Node3D
@onready var cylinder: MeshInstance3D = $Cylinder
@onready var torus: MeshInstance3D = $Torus
#swap visible on lock for gatekeeper
func on_completion():
	cylinder.visible = false
	torus.visible = true
