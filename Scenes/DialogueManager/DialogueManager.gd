extends Node

#enums for passing between NPCs and dialogue interaction
enum CONV_STATE {LISTEN, GIVE, RECEIVE, POST, COMPLETE, EASTER}
var dialogue_state : CONV_STATE = CONV_STATE.COMPLETE


@onready var text_box_scene = preload("res://Scenes/DialogueManager/text_box.tscn")


var canvas_layer : CanvasLayer

var dialogue_lines : Array[String] = []
var dialogue_lines_2 : Array[String] = []
var dialogue_lines_3 : Array[String] = []

var set_animation_at_2 : bool = false
var set_animation_at_3 : bool = false


var animation_point : int
var complex : bool = false
var append_once : bool = false


var dialogue_length : int
var current_line_index = 0
 
var text_box

var is_dialogue_active = false
var can_advance_line = false

func start_dialogue(CanvasLayer_in : CanvasLayer, lines: Array[String], lines_2: Array[String], lines_3: Array[String]):
	if is_dialogue_active:
		return
	canvas_layer = CanvasLayer_in
	dialogue_lines = lines
	dialogue_length = dialogue_lines.size()
	dialogue_state = CONV_STATE.LISTEN
	
	#handle wonk cases
	if lines_2 != []:
		complex = true
		dialogue_lines_2 = lines_2
		dialogue_state = CONV_STATE.GIVE
		if lines_3 != []:
			dialogue_lines_3 = lines_3
			set_animation_at_3 = true
		else:
			set_animation_at_2 = true
			
	_show_text_box(CanvasLayer_in)
	is_dialogue_active = true

func _show_text_box(CanvasLayer_in):
	text_box = text_box_scene.instantiate()
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	CanvasLayer_in.add_child(text_box)
	
	if complex:
		if set_animation_at_2:
			animation_point = dialogue_length
		dialogue_lines.append_array(dialogue_lines_2)
		dialogue_lines_2 = []
		if set_animation_at_3:
			animation_point = dialogue_length
		dialogue_lines.append_array(dialogue_lines_3)
		dialogue_lines_3 = []
		#dialogue_state = CONV_STATE.RECEIVE
		
	text_box.display_text(dialogue_lines[current_line_index])
	can_advance_line = false

func _on_text_box_finished_displaying():
	can_advance_line = true

func _unhandled_input(event):
	if(
		event.is_action_pressed("advance_dialogue") &&
		is_dialogue_active &&
		can_advance_line
	):
		text_box.queue_free()
		current_line_index += 1

		if current_line_index >= animation_point and complex:
			printt(current_line_index, animation_point)
			dialogue_state = CONV_STATE.RECEIVE
		
		if current_line_index >= dialogue_lines.size():
		#reset happense here
			is_dialogue_active = false
			current_line_index = 0
			set_animation_at_2 = false
			set_animation_at_3 = false
			append_once = false
			dialogue_state = CONV_STATE.COMPLETE
			return
			
		_show_text_box(canvas_layer)
