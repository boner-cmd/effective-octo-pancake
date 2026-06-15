extends CharacterBody3D
#camera tweaks
var player_cutscene_locator: Node3D
var _cam_frame_both: Camera3D
var _cam_player_give: Camera3D
var _cam_frame_both_puddles: Camera3D
var _cam_frame_animals: Camera3D
var _cam_player_receive: Camera3D

var npc_camera_locator = Node3D
var interaction_flip : bool = false
var temp_npc = Node3D
var clone : Node3D
var clone_item_get : Sprite3D
var clone_item_get_bg : AnimatedSprite3D
var clone_item_give : Sprite3D
var clone_item_give_bg : AnimatedSprite3D

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
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


#camera nonsense and can probably just be put into physics process but didn't want to do that because of compute
func player_interaction_camera() -> void:
	
	if DialogueManager.is_dialogue_active:
		if not clone: #makes clone for interaction
			clone = clown.duplicate()
			get_tree().root.add_child(clone)
			clown.visible = false
			clone.global_position = player_cutscene_locator.global_position
			clone.global_rotation = player_cutscene_locator.global_rotation
			clone._set_player_anim(clone.AnimStates.TALK)
			clone_item_get = clone.get_child(5).get_child(0)
			clone_item_get_bg = clone.get_child(5).get_child(1)
			clone_item_give = clone.get_child(6).get_child(0)
			clone_item_give_bg = clone.get_child(6).get_child(1)
			
		match DialogueManager.dialogue_state:
			DialogueManager.CONV_STATE.PLAYER_LISTEN:
				if Input.is_action_just_pressed("jump"):
					if clone.current_anim != clown.AnimStates.JUMP:
						clone._set_player_anim(clown.AnimStates.JUMP)
					else:
						clone._set_player_anim(clone.AnimStates.TALK)
				if DialogueManager.current_npc == QuestManager.CharacterName.O \
						or DialogueManager.current_npc == QuestManager.CharacterName.LAMP \
						or DialogueManager.current_npc == QuestManager.CharacterName.SLIME \
						or DialogueManager.current_npc == QuestManager.CharacterName.GREASE \
						or DialogueManager.current_npc == QuestManager.CharacterName.MASS:
					_cam_frame_both_puddles.make_current()
				elif DialogueManager.current_npc == QuestManager.CharacterName.DEER \
						or DialogueManager.current_npc == QuestManager.CharacterName.HORSE:
					_cam_frame_animals.make_current()
				else:
					_cam_frame_both.make_current()
			DialogueManager.CONV_STATE.PLAYER_GIVE:
				_cam_player_give.make_current()
				#vfx point
				clone._set_player_anim(clone.AnimStates.GIVE)
			DialogueManager.CONV_STATE.PLAYER_RECEIVE:
				_cam_player_receive.make_current()
				#vfx point
				clone._set_player_anim(clone.AnimStates.GET)
	else:
		if _cam_player_give:
			pass #vfx point
		if _cam_player_receive:
			pass #vfx point

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

func _process(_delta: float) -> void:
	player_interaction_camera()

func _physics_process(delta: float) -> void:
	if not ray_cast_3d.is_colliding(): #never gets reset to ray_cast_3d if it ever gets set
		current_raycast = reset_raycast
	
	if not DialogueManager.dialogue_state == DialogueManager.CONV_STATE.FINISHED:
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
		_camera.make_current()
		movement_frozen = false
		convo_flip_1 = true
		convo_flip_2 = true
		convo_flip_3 = true

		if clone:
			clone.queue_free()
			clown.visible = true
			clown._set_player_anim(clown.AnimStates.IDLE)

	if not movement_frozen:
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
