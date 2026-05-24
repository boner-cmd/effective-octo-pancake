extends Node3D
@onready var object_1: Node3D = $Object1
@onready var object_2: Node3D = $Object2
@onready var object_3: Node3D = $Object3
@onready var object_4: Node3D = $Object4

@onready var origin: MeshInstance3D = $MeshInstance3D


@onready var mesh_1: MeshInstance3D = $Object1/Mesh1
@onready var mesh_2: MeshInstance3D = $Object2/Mesh2
@onready var mesh_3: MeshInstance3D = $Object3/Mesh3
@onready var mesh_4: MeshInstance3D = $Object4/Mesh4


@onready var sphere: MeshInstance3D = $MeshInstance3D
var target_deg_min := 60
var result1 : float
var result2 : float
var result3 : float

func _spawn_check(var1 : Node3D, var2 : Node3D):
	var direction1 = (origin.position - var1.global_position)
	var direction2 = (origin.position - var2.global_position)
	var dot = direction1.dot(direction2)
	dot = clampf(dot, -1.0, 1.0)
	var rad = acos(dot)
	var res = rad_to_deg(rad)
	return res




func _randomize_spawn_2(obj1 : Node3D, obj2 : Node3D):
	obj1.rotation_degrees = Vector3(randf_range(0, 360.0), 0, randf_range(0, 360.0))
	print(obj1.rotation_degrees)
	obj2.rotation_degrees = Vector3(randf_range(0, 360.0), 0, randf_range(0, 360.0))
	print(obj2.rotation_degrees)
	#_spawn_check(mesh_1, mesh_2)
	
func _randomize_spawn_3():
	object_1.rotation_degrees = Vector3(randf_range(0, 360.0), 0, randf_range(0, 360.0))
	print(object_1.rotation_degrees)
	object_2.rotation_degrees = Vector3(randf_range(0, 360.0), 0, randf_range(0, 360.0))
	print(object_2.rotation_degrees)
	#object_3.rotation_degrees = Vector3(randf_range(0, 360.0), 0, randf_range(0, 360.0))
	#print(object_3.rotation_degrees)
	#_spawn_check(mesh_1, mesh_2)
	#_spawn_check(mesh_1, mesh_3, result2)
	#_spawn_check(mesh_2, mesh_3, result3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _spawn_check(mesh_1, mesh_2) < target_deg_min:
		_randomize_spawn_2(object_1, object_2)
	if _spawn_check(mesh_2, mesh_3) < target_deg_min:
		_randomize_spawn_2(object_2, object_3)
	if _spawn_check(mesh_2, mesh_1) < target_deg_min:
		_randomize_spawn_2(object_2, object_1)
