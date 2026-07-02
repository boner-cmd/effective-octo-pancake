extends MeshInstance3D
var mat


func _ready() -> void:
	mat = get_active_material(0)
	tween_object(mat, "uv1_offset:y", -1.0, 30.0, Tween.TRANS_LINEAR, Tween.EASE_IN)


func tween_object(object : Object, property : NodePath, goal : Variant, time : float, 
			transtype : Tween.TransitionType, easetype : Tween.EaseType) -> void:
	
	var tweened_object = get_tree().create_tween().set_loops()
	var tweener_object = tweened_object.tween_property(object, property, goal, time).from_current()
	tweener_object.set_trans(transtype).set_ease(easetype)
	tweened_object.play()
