extends CharacterBody3D
#camera tweaks

var temp_camera_position : Vector3
var temp_camera_rotation : Vector3
var use_temp_camera_door : bool = false
var temp_camera : Camera3D
var make_camera	: bool = true
var npc_camera_locator = Node3D
var temp_look : bool = true
var camera_target : Vector3
var temp_npc = Node3D

@onready var collision_shape_3d: CollisionShape3D = $ClownRigFBX/InteractionDetector/CollisionShape3D

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

@onready var reset_raycast: RayCast3D = $"../Reset_Raycast"
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var current_raycast : RayCast3D

#planet stuff
@export var planet : Node3D
@onready var clown: Node3D = $ClownRigFBX

#anim handling
@onready var current_anim = clown.AnimStates.IDLE

#audio stuff
var convo_flip_1 = true
var convo_flip_2 = true
var convo_flip_3 = true

#state stuff
var exit_check = false
var respawn_pos : Vector3 = Vector3(0.0, 0.1, 0.0)
var respawn_rot : Vector3 = Vector3(0.0, 0.0, 0.0)

var Idle_Check : bool = false

var move_direction : Vector3

var grav_strength : float = 10.0
var grav_vector : Vector3 = Vector3(0,0,0)
var xform : Transform3D

func reset_player():
	position = respawn_pos
	rotation = respawn_rot
	exit_check = false
	
func camera_point_interaction() -> void:
	camera_target = lerp(self.global_position, temp_npc.global_position, .5)

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

	if event.is_action_pressed("left") or event.is_action_pressed("right") or event.is_action_pressed("up") or event.is_action_pressed("down"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	if is_on_floor() and event.is_action_pressed("jump"):
		clown._set_player_anim(clown.AnimStates.JUMP)
		
func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * mouse_sensitivity

func _process(delta: float) -> void:
	#camera transition control
	if use_temp_camera_door or DialogueManager.dialogue_state != DialogueManager.CONV_STATE.FINISHED:
		if make_camera: #makes duplicate camera
			make_camera = false
			temp_camera = _camera.duplicate()
			get_tree().root.add_child(temp_camera)
			temp_camera.global_position = _camera.global_position
			temp_camera.global_rotation = _camera.global_rotation
			temp_camera.current = true
		if DialogueManager.dialogue_state != DialogueManager.CONV_STATE.FINISHED:
			if temp_look:
				#self.look_at(temp_npc.global_position)
				#self.rotation.x = 0
				#self.rotation.z = 0
				camera_point_interaction()
				temp_camera.global_position = npc_camera_locator.global_position
				temp_camera.look_at(camera_target, up_direction)
				temp_look = false
			
		#if use_temp_camera_door:
			#var weight : float = .02
			#temp_camera.global_position = temp_camera.global_position.lerp(temp_camera_position, weight * delta)
			#temp_camera.global_rotation.x = lerp_angle(temp_camera.global_rotation.x, temp_camera_rotation.x, weight * delta)
			#temp_camera.global_rotation.y = lerp_angle(temp_camera.global_rotation.y, temp_camera_rotation.y, weight * delta)
			#temp_camera.global_rotation.z = lerp_angle(temp_camera.global_rotation.z, temp_camera_rotation.z, weight * delta)
	elif temp_camera:
		temp_camera.queue_free()
		make_camera = true
		temp_look = true

func _physics_process(delta: float) -> void:
	if !ray_cast_3d.is_colliding():
		current_raycast = reset_raycast
	
	if !DialogueManager.dialogue_state == DialogueManager.CONV_STATE.FINISHED:
		match DialogueManager.dialogue_state:
			DialogueManager.CONV_STATE.PLAYER_LISTEN:
				if convo_flip_1:
					clown._set_player_anim(clown.AnimStates.TALK)
					convo_flip_1 = false
			DialogueManager.CONV_STATE.PLAYER_GIVE:
				if convo_flip_2:
					clown._set_player_anim(clown.AnimStates.GIVE)
					convo_flip_2 = false
			DialogueManager.CONV_STATE.PLAYER_RECEIVE:
				if convo_flip_3:
					clown._set_player_anim(clown.AnimStates.GET)
					convo_flip_3 = false
		movement_frozen = true
		
	elif exit_check:
		movement_frozen = true
		velocity = Vector3(0,0,0)
	else:
		movement_frozen = false
		convo_flip_1 = true
		convo_flip_2 = true
		convo_flip_3 = true

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
		align_with_floor(ray_cast_3d.get_collision_normal()) # get collision normal can return a zero vector if no collision
		global_transform = global_transform.interpolate_with(xform, .3)
		
		move_and_slide()
