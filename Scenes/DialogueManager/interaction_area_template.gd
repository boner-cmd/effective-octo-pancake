extends Node3D

@onready var interact_ui : MarginContainer = %interact
@onready var CanvasLayer_in: CanvasLayer = %CanvasLayer
@onready var speech_sound = preload("res://sound fx exports/typewriter2026-05-20_13_26_04.wav")

#change to group check also
var current_NPC : MeshInstance3D

#irrelevant based on quest system but needs implementation
var NPC_Normal_Template_Check : bool

#COMPLETE is to escape the current loop, might be redundant
#these lines to pass through should rely on global dialogue script
var lines: Array[String] = []
var lines_2: Array[String] = []
var lines_3: Array[String] = []

#these are obsolete based on global dialogue script
var initial_lines: Array[String] = []
var give_lines: Array[String] = []
var receive_lines: Array[String] = []
var post_lines: Array[String] = []
var easter_lines: Array[String] = []

#placeholder status for conversation state checking MIGHT be obsolete based on quest status
var temp_status : DialogueManager.CONV_STATE
var current_status: DialogueManager.CONV_STATE = DialogueManager.CONV_STATE.PLAYER_LISTEN:
	set(set_current_status):
		current_status = set_current_status
		print("status changed")

func conversation_dialogue():
	match current_status:
		DialogueManager.CONV_STATE.PLAYER_LISTEN:
			lines = initial_lines
			temp_status = DialogueManager.CONV_STATE.PLAYER_GIVE
			
		DialogueManager.CONV_STATE.PLAYER_GIVE:
			lines = give_lines
			if NPC_Normal_Template_Check:
				lines_2 = receive_lines
			
		DialogueManager.CONV_STATE.PLAYER_RECEIVE:
			lines = receive_lines
			temp_status = DialogueManager.CONV_STATE.COMPLETE
			
		DialogueManager.CONV_STATE.POST:
			lines = post_lines
			
		DialogueManager.CONV_STATE.EASTER:
			lines = easter_lines
			
		DialogueManager.CONV_STATE.COMPLETE:
			print("complete")
			
	print("something")
	print(lines)


#this should only run if child is an NPC
func interact() -> void:
	conversation_dialogue()
	current_NPC.current_state = current_status
	
	if current_status != DialogueManager.CONV_STATE.COMPLETE:
		DialogueManager.start_dialogue(CanvasLayer_in, lines, lines_2, lines_3, speech_sound)
		lines = []
		lines_2 = []
		lines_3 = []

#this needs to change to check group and pull lines from global dialogue
func _ready() -> void:
	current_NPC = get_child(2)
	NPC_Normal_Template_Check = current_NPC.NPC_Normal_Template_Check
	
	print(current_NPC)
	initial_lines = current_NPC.initial_lines
	give_lines = current_NPC.give_lines
	receive_lines = current_NPC.receive_lines
	post_lines = current_NPC.post_lines
	easter_lines = current_NPC.easter_lines

#this was important for a reason I don't remember probably debugging
func _on_canvas_layer_child_exiting_tree(_node: Node) -> void:
	if !DialogueManager.is_dialogue_active:
		current_status = temp_status
