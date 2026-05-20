extends Node

@onready var text_box_scene = preload("res://Scenes/DialogueManager/text_box.tscn")

var canvas_layer : CanvasLayer

var dialogue_lines : Array[String] = []
var current_line_index = 0

var text_box

var is_dialogue_active = false
var can_advance_line = false

func start_dialogue(CanvasLayer_in : CanvasLayer, lines: Array[String]):
	if is_dialogue_active:
		return
	canvas_layer = CanvasLayer_in
	dialogue_lines = lines
	_show_text_box(canvas_layer)
	
	is_dialogue_active = true

func _show_text_box(canvas_layer):
	text_box = text_box_scene.instantiate()
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	canvas_layer.add_child(text_box)
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
		if current_line_index >= dialogue_lines.size():
			is_dialogue_active = false
			current_line_index = 0
			return
			
		_show_text_box(canvas_layer)
