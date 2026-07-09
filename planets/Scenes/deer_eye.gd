extends Node3D
@onready var deer_pupil: Sprite3D = $EyeContainer/DeerPupil
@onready var eye_offset: Node3D = $"."
@onready var deer_eye: AnimatedSprite3D = $EyeContainer/DeerEye

var active_camera : Camera3D
var parent_deer
var completed : bool = false


func _ready() -> void:
	parent_deer = get_tree().get_first_node_in_group("Completion_Change")
	parent_deer.completion.connect(show_pupil)


func _process(delta: float) -> void:
	set_active()
	eye_offset.global_rotation.x = lerp_angle(eye_offset.global_rotation.x, active_camera.global_rotation.x, 2 * delta)
	eye_offset.global_rotation.y = lerp_angle(eye_offset.global_rotation.y, active_camera.global_rotation.y, 2 * delta)
	eye_offset.global_rotation.z = lerp_angle(eye_offset.global_rotation.z, active_camera.global_rotation.z, 2 * delta)
	eye_offset.global_position = active_camera.global_position
	if completed:
		if deer_eye.get_frame() == 5:
			deer_pupil.visible = false
		else:
			deer_pupil.visible = true


func check_active() -> bool:
	if get_viewport().get_camera_3d() == active_camera:
		return true
	else:
		return false


func set_active() -> void:
	if not check_active():
		active_camera = get_viewport().get_camera_3d()


func show_pupil() -> void:
	completed = true
	deer_pupil.visible = true
