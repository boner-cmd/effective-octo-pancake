extends CharacterBody3D

#camera tweaks
var player_cutscene_locator: Node3D ##Clone Locator for dialogue cutscenes
var _cam_frame_both: Camera3D
var _cam_player_give: Camera3D
var _cam_player_receive: Camera3D

var temp_npc = Node3D
var clone : Node3D
var clone_vfx : Node3D
var clone_item_get : Sprite3D
var clone_item_get_bg : AnimatedSprite3D
var clone_item_give : Sprite3D
var clone_item_give_bg : AnimatedSprite3D
var clone_flag : bool = false

var movement_frozen : bool = false
var _camera_input_direction : Vector2 = Vector2.ZERO

var exit_check = false
var respawn_pos : Vector3 = Vector3(0.0, 0.1, 0.0)
var respawn_rot : Vector3 = Vector3(0.0, 0.0, 0.0)
var Idle_Check : bool = false
var move_direction : Vector3
var grav_strength : float = 10.0
var grav_vector : Vector3 = Vector3(0,0,0)
var xform : Transform3D

enum _inputs {CONTROLLER, MOUSE}
var _input_used : _inputs = _inputs.MOUSE

@export_range(0.0, 1.0) var mouse_sensitivity : float = 0.25
@export var tilt_upper_limit := PI / 3.0
@export var tilt_lower_limit := -PI / 5.0
@export var move_speed : float = 3.75
@export var acceleration : float = 2000.0
@export var planet : Node3D

@onready var clown: Node3D = $ClownRigFBX
@onready var current_anim = clown.AnimStates.IDLE
@onready var _camera_pivot: Node3D = $CameraPivot
@onready var _camera: Camera3D = $CameraPivot/Camera3D
@onready var reset_raycast: RayCast3D = $"../Reset_Raycast"
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var current_raycast : RayCast3D
@onready var collision_shape_3d: CollisionShape3D = $ClownRigFBX/InteractionDetector/CollisionShape3D
@onready var player_vfx : Node3D = $ClownRigFBX/PlayerVFX


func reset_player():
	position = respawn_pos
	rotation = respawn_rot
	exit_check = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player_vfx.erase_current_effects()


func transfer_vfx_to_clone() -> void:
	for node in clone.get_children():
		if node.name == &"PlayerVFX":
			node.name = &"CloneVFX"
	player_vfx.reparent(clone)
	clone_vfx = player_vfx
	player_vfx.position = Vector3(0.0,0.0,0.0)
	player_vfx.rotation = Vector3(0.0,0.0,0.0)


func transfer_vfx_to_player() -> void:
	player_vfx.reparent(clown)
	player_vfx.position = Vector3(0.0,0.0,0.0)
	player_vfx.rotation = Vector3(0.0,0.0,0.0)


func player_interaction_camera() -> void:
	if DialogueManager.is_dialogue_active:
		Idle_Check = false
		if not clone_flag: #makes clone for interaction
			clone_flag = true
			clone = clown.duplicate()
			for node in clone.get_children():
				if node.name == &"InteractionDetector":
					node.queue_free()
			get_tree().root.add_child(clone)
			#clone.scale = Vector3(-1.0, 1.0, 1.0)
			transfer_vfx_to_clone()
			clown.visible = false
			clone.global_position = player_cutscene_locator.global_position
			clone.global_rotation = player_cutscene_locator.global_rotation
			clone._set_player_anim(clone.AnimStates.TALK)
			for node in clone.get_children():
				if node.name == &"ItemGetLocator":
					clone_item_get = node.get_child(0)
					clone_item_get_bg = node.get_child(1)
				if node.name == &"ItemGiveLocator":
					clone_item_give = node.get_child(0)
					clone_item_give_bg = node.get_child(1)
		match DialogueManager.dialogue_state:
			DialogueManager.CONV_STATE.PLAYER_LISTEN:
				if Input.is_action_just_pressed("jump"):
					if clone.current_anim != clone.AnimStates.JUMP:
						clone._set_player_anim(clone.AnimStates.JUMP)
					else:
						clone._set_player_anim(clone.AnimStates.TALK)
				elif clone.current_anim != clone.AnimStates.JUMP:
					clone._set_player_anim(clone.AnimStates.TALK)
				_cam_frame_both.make_current()
			DialogueManager.CONV_STATE.PLAYER_GIVE:
				_cam_player_give.make_current()
				clone._set_player_anim(clone.AnimStates.GIVE)
			DialogueManager.CONV_STATE.PLAYER_RECEIVE:
				_cam_player_receive.make_current()
				clone._set_player_anim(clone.AnimStates.GET)


func grav_calc():
	grav_vector = (planet.position - position).normalized()
	up_direction = -grav_vector


func align_with_floor(floor_normal : Vector3):
	xform = global_transform
	xform.basis.y = floor_normal
	xform.basis.x = -xform.basis.z.cross(floor_normal)
	xform.basis = xform.basis.orthonormalized()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test save"):
		SaveManager.save_game()
	if event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("left") \
			or event.is_action_pressed("right") \
			or event.is_action_pressed("up") \
			or event.is_action_pressed("down"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if is_on_floor() and event.is_action_pressed("jump"):
		if not DialogueManager.is_dialogue_active:
			clown._set_player_anim(clown.AnimStates.JUMP)


func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
		)
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * mouse_sensitivity
		_input_used = _inputs.MOUSE


func _process(_delta: float) -> void:
	player_interaction_camera()


func _physics_process(delta: float) -> void:
	if not ray_cast_3d.is_colliding(): #never gets reset to ray_cast_3d if it ever gets set
		current_raycast = reset_raycast
	if DialogueManager.dialogue_state != DialogueManager.CONV_STATE.FINISHED:
		movement_frozen = true
	elif clown.current_anim == clown.AnimStates.VICTORY:
		movement_frozen = true
	elif exit_check:
		movement_frozen = true
		velocity = Vector3(0,0,0)
	else:
		_camera.make_current()
		movement_frozen = false
		if clone_flag == true:
			clone_flag = false
			transfer_vfx_to_player()
			clone.queue_free()
			clown.visible = true
	if not movement_frozen:
		var camera_axis_input := Input.get_vector("camera_look_left", "camera_look_right", "camera_look_up", "camera_look_down")
		if camera_axis_input.length() >= .2:
			_camera_input_direction.x = camera_axis_input.x * 1.75
			_camera_input_direction.y = camera_axis_input.y * 1.75
			_input_used = _inputs.CONTROLLER
		
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
