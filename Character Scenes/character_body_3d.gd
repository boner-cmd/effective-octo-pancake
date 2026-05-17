extends CharacterBody3D

@export var gravity_strength :float = -12
@export var jump_impulse:= 3.0
var last_movement_direction := Vector3.FORWARD

func _physics_process(delta: float) -> void:
	
	var raw_input := Input.get_vector("left", "right", "up", "down")
	var forward :=  Vector3.FORWARD
	var right := Vector3.RIGHT
	var move_direction := forward * raw_input.y + right * raw_input.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	
	if move_direction.length() > 0.02:
		last_movement_direction = move_direction
	var target_angle = Vector3.FORWARD.signed_angle_to(last_movement_direction, Vector3.UP)
	global_rotation.y = lerp_angle(global_rotation.y, -target_angle, 10*delta)
	
	var y_velocity := velocity.y
	velocity.y = 0.0
	velocity = velocity.move_toward(move_direction, delta)
	velocity.y = y_velocity + gravity_strength * delta
	
	position.x = 0.0
	position.z = 0.0
	
	var is_starting_jump := Input.is_action_pressed("jump") and is_on_floor()
	if is_starting_jump:
		velocity.y += jump_impulse
		
	move_and_slide()
