extends Node3D
@onready var object_1: Node3D = $Object1
@onready var object_2: Node3D = $Object2
@onready var object_3: Node3D = $Object3
@onready var object_4: Node3D = $Object4

@onready var area_3d_1: Area3D = $Object1/Mesh1/Area3D
@onready var area_3d_2: Area3D = $Object2/Area3D
@onready var area_3d_3: Area3D = $Object3/Area3D
@onready var area_3d_4: Area3D = $Object4/Area3D

func _randomize(obj: Node3D):
	obj.rotation_degrees = Vector3(randi_range(0, 360), 0, randi_range(0, 360))



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_randomize(object_1)
	#_randomize(object_2)
	#_randomize(object_3)
	#_randomize(object_4)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#while area_3d_2.overlaps_area(area_3d_1):
		#_randomize(object_2)
	#while area_3d_2.overlaps_area(area_3d_3):
		#_randomize(object_2)
	#while area_3d_2.overlaps_area(area_3d_4):
		#_randomize(object_2)
		
		
		
	if area_3d_2.has_overlapping_bodies():
		_randomize(object_2)
	if area_3d_3.has_overlapping_bodies():
		_randomize(object_3)
	if area_3d_4.has_overlapping_bodies():
		_randomize(object_4)
	
	
