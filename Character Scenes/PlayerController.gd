extends CharacterBody3D
#camera tweaks
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25
@export var tilt_upper_limit := PI / 3.0
@export var tilt_lower_limit := -PI / 5.0
#character
@export var move_speed := 3.75
@export var acceleration := 2000.0

var _camera_input_direction := Vector2.ZERO

@onready var _camera_pivot: Node3D = $CameraPivot
@onready var _camera: Camera3D = $CameraPivot/Camera3D

#planet stuff
@export var planet : Node3D

@onready var clown: Node3D = $ClownRigFBX

#anim handling
var anim_tree : AnimationTree
var blend_speed := 50.0

enum {IDLE, WALK, JUMP, GET, GIVE, TALK, VICTORY}
var current_anim = IDLE

var walk_val : float = 0.0
var talk_val : float = 0.0
var get_val : float = 0.0
var give_val : float = 0.0
var vic_val : float = 0.0

var Vic_Reset : bool = false
var Walk_Reset : bool = false
var Idle_Check : bool = false

func handle_animations(delta):
	match current_anim:
		IDLE:
			walk_val = lerpf(walk_val, 0.0, blend_speed * delta)
			talk_val = lerpf(talk_val, 0.0, blend_speed * delta)
			get_val = lerpf(get_val, 0.0, blend_speed * delta)
			give_val = lerpf(give_val, 0.0, blend_speed * delta)
			vic_val = 0.0
			Walk_Reset = true
		WALK:
			if Walk_Reset:
				anim_tree.set("parameters/Reset_Walk/seek_request", 0.0)
				Walk_Reset = false
			walk_val = lerpf(walk_val, 1.0, blend_speed * delta)
			talk_val = lerpf(talk_val, 0.0, blend_speed * delta)
			get_val = lerpf(get_val, 0.0, blend_speed * delta)
			give_val = lerpf(give_val, 0.0, blend_speed * delta)
			vic_val = 0.0
		JUMP:
			walk_val = 0.0
			talk_val = 0.0
			get_val = 0.0
			give_val = 0.0
			vic_val = 0.0
			Walk_Reset = true
		TALK:
			walk_val = lerpf(walk_val, 0.0, blend_speed * delta)
			talk_val = 1.0
			get_val = lerpf(get_val, 0.0, blend_speed * delta)
			give_val = lerpf(give_val, 0.0, blend_speed * delta)
			vic_val = 0.0
		GET:
			walk_val = lerpf(walk_val, 0.0, blend_speed * delta)
			talk_val = 1.0
			get_val = lerpf(get_val, 1.0, blend_speed * delta)
			give_val = lerpf(give_val, 0.0, blend_speed * delta)
			vic_val = 0.0
		GIVE:
			walk_val = lerpf(walk_val, 0.0, blend_speed * delta)
			talk_val = 1.0
			get_val = lerpf(get_val, 0.0, blend_speed * delta)
			give_val = lerpf(give_val, 1.0, blend_speed * delta)
			vic_val = 0.0
		VICTORY:
			if Vic_Reset:
				anim_tree.set("parameters/Reset_Victory/seek_request", 0.0)
				Vic_Reset = false
			walk_val = 0.0
			talk_val = 0.0
			get_val = 0.0
			give_val = 0.0
			vic_val = 1.0

func update_tree():
	anim_tree["parameters/Walk/blend_amount"] = walk_val
	anim_tree["parameters/Talk/blend_amount"] = talk_val
	anim_tree["parameters/Get/blend_amount"] = get_val
	anim_tree["parameters/Give/blend_amount"] = give_val
	anim_tree["parameters/Victory/blend_amount"] = vic_val

var move_direction : Vector3

var grav_strength : float = 10.0
var grav_vector : Vector3 = Vector3(0,0,0)
var xform : Transform3D

func grav_calc():
	grav_vector = (planet.position - position).normalized()
	up_direction = -grav_vector
	
func align_with_floor(floor_normal):
	xform = global_transform
	xform.basis.y = floor_normal
	xform.basis.x = -xform.basis.z.cross(floor_normal)
	xform.basis = xform.basis.orthonormalized()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and $"../MapUI".visible == false:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
		#set explosion
		Vic_Reset = true
		current_anim = VICTORY
		
	if event.is_action_pressed("toggle_map"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		

		
	if is_on_floor() and event.is_action_pressed("jump"):
		current_anim = JUMP
		anim_tree.set("parameters/Jump/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * mouse_sensitivity

func _ready() -> void:
	anim_tree = clown.get_node("AnimationTree")

func _physics_process(delta: float) -> void:
	handle_animations(delta)
	update_tree()
	
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
		clown.rotation.y = _camera_pivot.rotation.y - deg_to_rad(rad_to_deg(raw_input.angle()) + 90)
		Idle_Check = true
		current_anim = WALK
		
	elif Idle_Check:
		anim_tree.set("parameters/Reset_Idle/seek_request", 0.0)
		current_anim = IDLE
		Idle_Check = false
	
	grav_calc()
	velocity = velocity.move_toward((move_direction * move_speed) + (grav_vector * grav_strength), acceleration * delta)
	
	#align character with floor
	align_with_floor($RayCast3D.get_collision_normal())
	global_transform = global_transform.interpolate_with(xform, .3)
	
	move_and_slide()
