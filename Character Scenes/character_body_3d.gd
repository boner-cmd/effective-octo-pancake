extends CharacterBody3D

@export var gravity_strength :float = -12
@export var jump_impulse:= 3.0
@export var planet : StaticBody3D

var last_movement_direction := Vector3.FORWARD

var grav_vector : Vector3 = Vector3(0,0,0)
var player_vector : Vector3 = Vector3(0,0,0)
var xform : Transform3D


func grav_calc():
	if planet:
		grav_vector = planet.position - position
		player_vector = position - planet.position
		up_direction = -grav_vector
	else:
		grav_vector = Vector3(0.0, 0.0, 0.0)

func align_with_floor(floor_normal):
	xform = global_transform
	xform.basis.y = floor_normal
	xform.basis.x = -xform.basis.z.cross(floor_normal)
	xform.basis = xform.basis.orthonormalized()

func _physics_process(delta: float) -> void:

	# Add the gravity.
	grav_calc()
	velocity = grav_vector
	#align character with floor
	if is_on_floor():
		align_with_floor($RayCast3D.get_collision_normal())
		global_transform = global_transform.interpolate_with(xform, 0.1)

	move_and_slide()
