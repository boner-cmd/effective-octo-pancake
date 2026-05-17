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

	#doesn't work
	var raw_input := Input.get_vector("left", "right", "up", "down")
	var forward :=  Vector3.FORWARD
	var right := Vector3.RIGHT
	var move_direction := forward * raw_input.y + right * raw_input.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()

	# Add the gravity.
	grav_calc()
	velocity = grav_vector
	#align character with floor
	if is_on_floor():
		align_with_floor($RayCast3D.get_collision_normal())
		global_transform = global_transform.interpolate_with(xform, 0.1)



	if move_direction.length() > 0.02:
		last_movement_direction = move_direction
	var target_angle = Vector3.FORWARD.signed_angle_to(last_movement_direction, Vector3.UP)
	global_rotation.y = lerp_angle(global_rotation.y, -target_angle, 10*delta)


	var y_velocity := velocity.y
	velocity.y = 0.0
	velocity = velocity.move_toward(move_direction, delta)
	velocity.y = y_velocity + gravity_strength * delta

	#doesn't work
	var is_starting_jump := Input.is_action_pressed("jump") and is_on_floor()
	if is_starting_jump:
		velocity += velocity * jump_impulse


	move_and_slide()
