extends Node3D
@onready var player: Node3D = $ClownRigFBX
var hud_overlay : CanvasLayer
var main_scene : Node3D
var dialogue_vignette
@onready var camera_3d: Camera3D = $Camera3D
var player_player : CharacterBody3D

func end_sequence() -> void:
	player._set_player_anim(player.AnimStates.VICTORY)
	await hud_overlay.transition_victory()
	main_scene.on_planet_change_requested(0)
	player_player._camera.make_current()


func _ready() -> void:
	for node in get_tree().root.get_children():
		if node.name == &"MainScene":
			main_scene = node
	for node in main_scene.get_children():
		if node.name == &"HUDOverlay":
			hud_overlay = node
	player_player = get_tree().get_first_node_in_group("Player")
	await get_tree().create_timer(.2).timeout
	DialogueManager.start_dialogue(hud_overlay, QuestManager.CharacterName.CREDITS, AudioManager.speech_sound)
	camera_3d.make_current()
