extends Node3D

@export var Canvas : CanvasLayer
@export var interact_ui : MarginContainer
@onready var CanvasLayer_in: CanvasLayer = %CanvasLayer

enum CONV_STATE {LISTEN, GIVE, RECEIVE, POST, COMPLETE, EASTER}
#LISTEN is for the initial conversation
#GIVE is for giving the NPC the required item
#RECEIVE is for getting the reward from the NPC
#POST is the NPC lines after task complete
#EASTER is for the post victory conversations

#COMPLETE is to escape the current loop

var lines: Array[String] = ["default lines"]
var initial_lines: Array[String] = ["initial lines"]
var give_lines: Array[String] = ["give lines"]
var receive_lines: Array[String] = ["receive lines"]
var post_lines: Array[String] = ["post lines"]
var easter_lines: Array[String] = ["easter lines"]

#placeholder status
var temp_status : CONV_STATE
var current_status: CONV_STATE = CONV_STATE.LISTEN:
	set(set_current_status):
		current_status = set_current_status
		print("status changed")

func conversation_dialogue():
	match current_status:
		CONV_STATE.LISTEN:
			lines = initial_lines
			_listen.emit()
			temp_status = CONV_STATE.GIVE
			
		CONV_STATE.GIVE:
			lines = give_lines
			_give.emit()
			temp_status = CONV_STATE.RECEIVE
			
		CONV_STATE.RECEIVE:
			lines = receive_lines
			_receive.emit()
			temp_status = CONV_STATE.COMPLETE
			
		CONV_STATE.POST:
			lines = post_lines
			_listen.emit()
			
		CONV_STATE.EASTER:
			lines = easter_lines
			_listen.emit()
				
		CONV_STATE.COMPLETE:
			print("complete")
	print("something")
	print(lines)

func interact() -> void:
	conversation_dialogue()
	if current_status != CONV_STATE.COMPLETE:
		DialogueManager.start_dialogue(CanvasLayer_in, lines)
		

func _ready() -> void:
	Canvas = CanvasLayer_in

signal _listen()
signal _give()
signal _receive()
signal _complete()


func _on_canvas_layer_child_exiting_tree(node: Node) -> void:
	if !DialogueManager.is_dialogue_active:
		current_status = temp_status
		_complete.emit()
