extends Node3D
const LARGE_SNOWFLAKE_MATERIAL_OVERLAY_1 = preload("uid://cqforpvl84r1m")
const LARGE_SNOWFLAKE_MATERIAL_OVERLAY_2 = preload("uid://cinpdpc68ilyk")

var y_off_max : float = 80.0
var y_off_min : float = 40.0
var scale_off_max : float = 14.0
var scale_off_min : float = 10.0
var current_tweens : Dictionary = {}
var direction_flip : int = -1


func _ready() -> void:
	for offset in get_children():
		var sprite : Sprite3D = offset.get_child(0)
		sprite.position.y = randf_range(y_off_min, y_off_max)
		sprite.rotation_degrees.x = randf_range(0, 45)
		sprite.rotation_degrees.z = randf_range(0, 45)
		var sprite_scale = randf_range(scale_off_min, scale_off_max)
		sprite.scale = Vector3(sprite_scale, sprite_scale, sprite_scale)
		tween_object(sprite, "rotation:y", deg_to_rad(360.0 * direction_flip), randf_range(15.0, 30.0), Tween.TRANS_LINEAR, Tween.EASE_IN)
		direction_flip *= -1
		if sprite.position.y >= 67.0:
			sprite.material_overlay = LARGE_SNOWFLAKE_MATERIAL_OVERLAY_1
		elif sprite.position.y < 67.0:
			sprite.material_overlay = LARGE_SNOWFLAKE_MATERIAL_OVERLAY_2
		elif sprite.position.y < 54.0:
			sprite.material_overlay = null


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
