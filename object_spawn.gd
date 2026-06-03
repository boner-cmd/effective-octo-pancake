extends Node3D

@export var InteractionArea : Node3D
@export var Obj_2 : Node3D
@export var Obj_3 : Node3D
@export var Obj_4 : Node3D
@export var Obj_5 : Node3D


var obj_determine_placement : Array = [
	0,
	1,
	2,
	3,
	4,
]

const obj_pos_1_const : Array = [
Vector3(349.0, 0.0, 268.0),
Vector3(341.0, 0.0, 180.0),
Vector3(333.0, 0.0, 21.0),
Vector3(266.0, 0.0, 356.0),
Vector3(22.0, 0.0, 83.0),
]
const obj_pos_2_const : Array =[
Vector3(298.0, 0.0, 96),
Vector3(317.0, 0.0, 294.0),
Vector3(332.0, 0.0, 198.0),
Vector3(212.0, 0.0, 189.0),
Vector3(241.0, 0.0, 0.0),
]
const obj_pos_3_const : Array =[
Vector3(293.0, 0.0, 235.0),
Vector3(247.0, 0.0, 164.0),
Vector3(15.0, 0.0, 98),
Vector3(206.0, 0.0, 4.0),
Vector3(300.0, 0.0, 0.0),
]
const obj_pos_4_const : Array =[
Vector3(348.0, 0.0, 200.0),
Vector3(102.0, 0.0, 232.0),
Vector3(171.0, 0.0, 97),
Vector3(152.0, 0.0, 155.0),
Vector3(45.0, 0.0, 0.0),
]
const obj_pos_5_const : Array =[
Vector3(119.0, 0.0, 206.0),
Vector3(334.0, 0.0, 205.0),
Vector3(24.0, 0.0, 352.0),
Vector3(17.0, 0.0, 126.0),
Vector3(78.0, 0.0, 37.0),
]

var obj_pos_1 : Array
var obj_pos_2 : Array
var obj_pos_3 : Array
var obj_pos_4 : Array 
var obj_pos_5 : Array 
var Array_Choice : int
var order : Array

func reset_array() -> void:
	obj_pos_1 = obj_pos_1_const.duplicate(true)
	obj_pos_2 = obj_pos_2_const.duplicate(true)
	obj_pos_3 = obj_pos_3_const.duplicate(true)
	obj_pos_4 = obj_pos_4_const.duplicate(true)
	obj_pos_5 = obj_pos_5_const.duplicate(true)

#pick an array
func placement():
	reset_array()
	Array_Choice = obj_determine_placement.pick_random()
	if Array_Choice == 0:
		order = obj_pos_1
	if Array_Choice == 1:
		order = obj_pos_2
	if Array_Choice == 2:
		order = obj_pos_3
	if Array_Choice == 3:
		order = obj_pos_4
	if Array_Choice == 4:
		order = obj_pos_5
	order.shuffle()
	
	if InteractionArea:
		InteractionArea.rotation_degrees = order.pop_back()
	if Obj_2:
		Obj_2.rotation_degrees = order.pop_back()
	if Obj_3:
		Obj_3.rotation_degrees = order.pop_back()
	if Obj_4:
		Obj_4.rotation_degrees = order.pop_back()
	if Obj_5:
		Obj_5.rotation_degrees = order.pop_back()


func _ready() -> void:
	placement()
	await Obj_2.ready
	if Obj_2:
		await Obj_2.tree_entered
		Obj_2.request_ready()
		Obj_2.stasis()
	if Obj_3:
		await Obj_3.tree_entered
		Obj_3.request_ready()
		Obj_3.stasis()
	if Obj_4:
		await Obj_4.tree_entered
		Obj_4.request_ready()
		Obj_4.stasis()
	if Obj_5:
		await Obj_5.tree_entered
		Obj_5.request_ready()
		Obj_5.stasis()
	
	
	
	
