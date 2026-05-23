extends CharacterBody3D
#camera tweaks
@export_range(0.0, 1.0) var mouse_sensitivity : float = 0.25
@export var tilt_upper_limit := PI / 3.0
@export var tilt_lower_limit := -PI / 5.0
#character
@export var move_speed : float = 3.75
@export var acceleration : float = 2000.0
var movement_frozen : bool = false
var _camera_input_direction : Vector2 = Vector2.ZERO

@onready var _camera_pivot: Node3D = $CameraPivot
@onready var _camera: Camera3D = $CameraPivot/Camera3D

#planet stuff
@export var planet : Node3D
@onready var clown: Node3D = $ClownRigFBX

#anim handling
@onready var current_anim = clown.AnimStates.IDLE

var Idle_Check : bool = false

var move_direction : Vector3

var grav_strength : float = 10.0
var grav_vector : Vector3 = Vector3(0,0,0)
var xform : Transform3D

func grav_calc():
	grav_vector = (planet.position - position).normalized()
	up_direction = -grav_vector
	
func align_with_floor(floor_normal : Vector3):
	xform = global_transform
	xform.basis.y = floor_normal
	xform.basis.x = -xform.basis.z.cross(floor_normal)
	xform.basis = xform.basis.orthonormalized()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
		clown._set_player_anim(clown.AnimStates.VICTORY)
	
	if event.is_action_pressed("left") or event.is_action_pressed("right") or event.is_action_pressed("up") or event.is_action_pressed("down"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	if event.is_action_pressed("toggle_map"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if is_on_floor() and event.is_action_pressed("jump"):
		clown._set_player_anim(clown.AnimStates.JUMP)

func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * mouse_sensitivity

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if DialogueManager.is_dialogue_active == true:
		match DialogueManager.dialogue_state:
			DialogueManager.CONV_STATE.PLAYER_LISTEN:
				clown._set_player_anim(clown.AnimStates.TALK)
			DialogueManager.CONV_STATE.PLAYER_GIVE:
				clown._set_player_anim(clown.AnimStates.GIVE)
			DialogueManager.CONV_STATE.PLAYER_RECEIVE:
				clown._set_player_anim(clown.AnimStates.GET)
			DialogueManager.CONV_STATE.COMPLETE:
				clown._set_player_anim(clown.AnimStates.IDLE)
		movement_frozen = true
	else:
		movement_frozen = false

	if !movement_frozen:
		_camera_pivot.rotation.x -= _camera_input_direction.y * delta
		_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, tilt_lower_limit, tilt_upper_limit)
		_camera_pivot.rotation.y -= _camera_input_direction.x * delta

		_camera_input_direction = Vector2.ZERO

		var raw_input := Input.get_vector("left", "right", "up", "down")
		var forward := _camera.global_basis.z
		var right := _camera.global_basis.x

		move_direction = forward * raw_input.y + right * raw_input.x
		move_direction = move_direction.normalized()

		#rotate char mesh
		if raw_input != Vector2(0,0):
			clown.rotation.y = _camera_pivot.rotation.y - (raw_input.angle() + PI/2)
			Idle_Check = true
			if clown.current_anim != clown.AnimStates.WALK:
				clown._set_player_anim(clown.AnimStates.WALK)
			
		elif Idle_Check:
			clown._set_player_anim(clown.AnimStates.IDLE)
			Idle_Check = false

		grav_calc()

		velocity = velocity.move_toward((move_direction * move_speed) + (grav_vector * grav_strength), acceleration * delta)

		#align character with floor
		align_with_floor($RayCast3D.get_collision_normal()) # get collision normal can return a zero vector if no collision
		global_transform = global_transform.interpolate_with(xform, .3)
		
		move_and_slide()
