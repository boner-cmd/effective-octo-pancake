extends CharacterBody3D

@export var gravity_strength :float = -12
@export var jump_impulse:= 3.0

func _physics_process(delta: float) -> void:
	
	var y_velocity := velocity.y
	velocity.y = 0
	velocity.y = y_velocity + gravity_strength * delta
	
	var is_starting_jump := Input.is_action_pressed("jump") and is_on_floor()
	if is_starting_jump:
		velocity.y += jump_impulse
		
	move_and_slide()
