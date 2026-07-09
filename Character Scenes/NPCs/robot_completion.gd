extends Node3D

@onready var gears_group: Node3D = $Gears

var y_off_max : float = 80.0
var y_off_min : float = 40.0
var scale_off_max : float = 1200.0
var scale_off_min : float = 700.0
var current_tweens : Dictionary = {}


func _ready() -> void:
	for gear_offset in gears_group.get_children():
		var gear : MeshInstance3D = gear_offset.get_child(0)
		gear.position.y = randf_range(y_off_min, y_off_max)
		gear.rotation_degrees.x = randf_range(0, 360)
		gear.rotation_degrees.z = randf_range(0, 360)
		var gear_scale = randf_range(scale_off_min, scale_off_max)
		gear.scale = Vector3(gear_scale, gear_scale, gear_scale)
	on_completion()


func on_completion() -> void:
	if QuestManager.has_completed(QuestManager.CharacterName.ROBOT):
		tween_gears()
	else:
		tween_gears_stuck()


func tween_gears_stuck() -> void:
	for gear_offset in gears_group.get_children():
		var gear : MeshInstance3D = gear_offset.get_child(0)
		var rot_goal : float = deg_to_rad(randf_range(10.0, 30.0))
		tween_object(gear, "rotation:y", rot_goal, randf_range(6.0, 12.0), Tween.TRANS_BOUNCE, Tween.EASE_IN)


func tween_gears() -> void:
	for gear_offset in gears_group.get_children():
		var gear : MeshInstance3D = gear_offset.get_child(0)
		tween_object(gear, "rotation:y", deg_to_rad(360.0), randf_range(5.0, 9.0), Tween.TRANS_LINEAR, Tween.EASE_IN)


func tween_object(object : Object, property : NodePath, goal : Variant, time : float, 
			transtype : Tween.TransitionType, easetype : Tween.EaseType) -> void:
	
	if object.is_in_group("Current_Tweened_Objects"):
		current_tweens[object].kill()
		current_tweens.erase(object)
		object.remove_from_group("Current_Tweened_Objects")
	
	object.add_to_group("Current_Tweened_Objects")
	var tweened_object = get_tree().create_tween().set_loops()
	tweened_object.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	current_tweens[object] = tweened_object
	var tweener_object = tweened_object.tween_property(object, property, goal, time).as_relative()
	tweener_object.set_trans(transtype).set_ease(easetype)
	tweened_object.play()
	await tweened_object.finished
	current_tweens.erase(object)
	object.remove_from_group("Current_Tweened_Objects")
	if tweened_object and tweened_object.is_valid():
		tweened_object.kill()
