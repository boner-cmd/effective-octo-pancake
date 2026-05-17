extends CharacterBody3D
#camera tweaks
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25
@export var tilt_upper_limit := PI / 3.0
@export var tilt_lower_limit := -PI / 8.0
#character
@export var move_speed := 8.0
@export var acceleration := 20.0

var _camera_input_direction := Vector2.ZERO

@onready var _camera_pivot: Node3D = $CameraPivot
@onready var _camera: Camera3D = $CameraPivot/Camera3D

@export var planet : Node3D

var grav_strength : float = 10.0
var grav_vector : Vector3 = Vector3(0,0,0)
var xform : Transform3D

func grav_calc():
	grav_vector = planet.position - position
	up_direction = -grav_vector
	
func align_with_floor(floor_normal):
	xform = global_transform
	xform.basis.y = floor_normal
	xform.basis.x = -xform.basis.z.cross(floor_normal)
	xform.basis = xform.basis.orthonormalized()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * mouse_sensitivity


func _physics_process(delta: float) -> void:
	_camera_pivot.rotation.x -= _camera_input_direction.y * delta
	_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, tilt_lower_limit, tilt_upper_limit)
	_camera_pivot.rotation.y -= _camera_input_direction.x * delta

	_camera_input_direction = Vector2.ZERO

	var raw_input := Input.get_vector("left", "right", "up", "down")
	var forward := _camera.global_basis.z
	var right := _camera.global_basis.x
	var move_direction := forward * raw_input.y + right * raw_input.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()

	grav_calc()
	
	#if not is_on_floor():
		#velocity = grav_vector
		
	velocity = velocity.move_toward((move_direction * move_speed) + grav_vector, acceleration * delta)
	
	#align character with floor
	if is_on_floor():
		align_with_floor($RayCast3D.get_collision_normal())
		global_transform = global_transform.interpolate_with(xform, 0.1)
	
	
	move_and_slide()
