extends Control
@onready var cloud_pivot: Control = $CloudPivot
@onready var cloud_lower_bounds: Sprite2D = $CloudPivot/CloudLowerBounds
@onready var cloud_temp_1: Sprite2D = $CloudPivot/CloudTemp1
@onready var cloud_temp_2: Sprite2D = $CloudPivot/CloudTemp2
@onready var cloud_temp_3: Sprite2D = $CloudPivot/CloudTemp3
@onready var cloud_temp_4: Sprite2D = $CloudPivot/CloudTemp4
@onready var cloud_temp_5: Sprite2D = $CloudPivot/CloudTemp5
@onready var cloud_temp_6: Sprite2D = $CloudPivot/CloudTemp6
@onready var cloud_temp_7: Sprite2D = $CloudPivot/CloudTemp7
@onready var cloud_temp_8: Sprite2D = $CloudPivot/CloudTemp8
@export var cloud_scale_start: float = .025 #change this to adjust starting cloud scale
var cloud_scale_end: float = 1.4
var cloud_size: Vector2 = Vector2(cloud_scale_start,cloud_scale_start)
@export var cloud_time: float = 30.0

@onready var cloud_array: Array = [cloud_temp_1, cloud_temp_2, cloud_temp_3, cloud_temp_4, cloud_temp_5, cloud_temp_6, cloud_temp_7, cloud_temp_8]
@onready var delay_time: float = cloud_time/cloud_array.size()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.ready.connect(tween_clouds)
	print(delay_time)
	
func tween_clouds() -> void:
	for clouds in cloud_array:
		tween_object(clouds,"position:y",-1032.0,cloud_time,Tween.TRANS_QUAD,Tween.EASE_IN) #Adjust TRANS_TYPE as lowerbounds cloud scale is adjusted
		tween_object(clouds,"scale",Vector2(cloud_scale_end,cloud_scale_end),cloud_time,Tween.TRANS_SINE,Tween.EASE_IN)
		await get_tree().create_timer(delay_time).timeout
	

func tween_object(object : Object, property : NodePath, goal : Variant, time : float, 
			transtype : Tween.TransitionType, easetype : Tween.EaseType) -> void:
	var tweened_object = get_tree().create_tween().set_loops()
	tweened_object.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	var tweener_object
	if property == ^"position:y": 
		tweener_object = tweened_object.tween_property(object, property, goal, time).from(0.0)
	elif property == ^"scale":
		tweener_object = tweened_object.tween_property(object, property, goal, time).from(cloud_size)
	else:
		tweener_object = tweened_object.tween_property(object, property, goal, time)
	tweener_object.set_trans(transtype).set_ease(easetype)
	tweened_object.play()
	await tweened_object.finished
	if tweened_object and tweened_object.is_valid():
		tweened_object.kill()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
