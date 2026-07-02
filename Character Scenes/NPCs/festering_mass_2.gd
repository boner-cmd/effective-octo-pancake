extends Node3D

@onready var festering_mass: MeshInstance3D = $FesteringMass
@onready var timer: Timer = $Timer
var offset_int : int = 0
var mat : StandardMaterial3D

func _ready() -> void:
	mat = festering_mass.get_surface_override_material(0)
	timer.timeout.connect(move_texture)
	timer.start()

func move_texture() -> void:
	match offset_int:
		0:
			mat.uv1_offset.x = 0.0
			mat.grow_amount = 0.00
			offset_int += 1
		1:
			mat.uv1_offset.x = -0.01
			mat.grow_amount = 0.001
			offset_int += 1
		2:
			mat.uv1_offset.y = 0.0
			mat.grow_amount = 0.002
			offset_int += 1
		3:
			mat.uv1_offset.y = -0.01
			mat.grow_amount = 0.003
			offset_int += 1
		4:
			mat.uv1_offset.x = 0.0
			mat.grow_amount = 0.004
			offset_int += 1
		5:
			mat.uv1_offset.x = 0.01
			mat.grow_amount = 0.003
			offset_int += 1
		6:
			mat.uv1_offset.y = 0.0
			mat.grow_amount = 0.002
			offset_int += 1
		7:
			mat.uv1_offset.y = 0.01
			mat.grow_amount = 0.001
			offset_int = 0
