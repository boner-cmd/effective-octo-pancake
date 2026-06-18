extends Control

var starting_cloud_flag : bool = false
var iteration_int : int = 0
var custom_step : float = 0.0
var cloud_pivot_count : int = 18
var clone_iteration : int = 0
var tween_array : Array
var pivot_offset_float : float
var cloud_array: Array = []
var delay_time: float

@onready var cloud_pivot: Control = $CloudPivot

@export var cloud_size_start: float = .25 #change this to adjust starting cloud scale
@export var cloud_size_end : float = 1.4
@export var cloud_time: float = 30.0


func _ready() -> void:
	ready.connect(big_cloud_tween)


func big_cloud_tween() -> void:
	for cloud in cloud_pivot.get_children():
		cloud_array.append(cloud)
	delay_time = cloud_time/cloud_array.size()
	cloud_pivots()
	tween_object(self, "rotation", 2*PI, 150.0, Tween.TRANS_LINEAR, Tween.EASE_IN)


func cloud_pivots() -> void:
	for i in cloud_pivot_count:
		clone_iteration += 1
		pivot_offset_float = clone_iteration * 2.5
		var cloud_clone = cloud_pivot.duplicate()
		var cloud_clone_array : Array
		for cloud in cloud_clone.get_children():
			cloud_clone_array.append(cloud)
		tween_clouds(cloud_clone_array)
		cloud_clone.rotation_degrees = round(360.0/cloud_pivot_count * clone_iteration)
		add_child(cloud_clone)


func tween_clouds(new_array : Array) -> void:
	for clouds in new_array:
		iteration_int += 1
		tween_object(clouds, "position:y", -1232.0, cloud_time, Tween.TRANS_SINE, Tween.EASE_IN) #Adjust TRANS_TYPE as lowerbounds cloud scale is adjusted
		tween_object(clouds, "scale", Vector2(cloud_size_end,cloud_size_end), cloud_time, Tween.TRANS_QUAD, Tween.EASE_IN)


func tween_object(object : Object, property : NodePath, goal : Variant, time : float, 
			transtype : Tween.TransitionType, easetype : Tween.EaseType) -> void:
	var tweened_object = get_tree().create_tween().set_loops()
	tween_array.append(tweened_object)
	var tweener_object
	tweened_object.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	
	if property == ^"position:y": 
		tweener_object = tweened_object.tween_property(object, property, goal, time).from(0.0)
	elif property == ^"scale":
		tweener_object = tweened_object.tween_property(object, property, goal, time).from(Vector2(cloud_size_start,cloud_size_start))
	elif property == ^"rotation":
		tweener_object = tweened_object.tween_property(object, property, goal, time).from(0.0)
	else:
		tweener_object = tweened_object.tween_property(object, property, goal, time)
	
	tweened_object.custom_step(delay_time * iteration_int + pivot_offset_float)
	tweener_object.set_trans(transtype).set_ease(easetype)
	tweened_object.play()
