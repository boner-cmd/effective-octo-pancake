extends Node3D
@onready var player: Node3D = $ClownRigFBX
var hud_overlay : CanvasLayer
var main_scene : Node3D
var dialogue_vignette


func end_sequence() -> void:
	player._set_player_anim(player.AnimStates.VICTORY)
	await hud_overlay.transition_victory()
	main_scene.on_planet_change_requested(0)


func _ready() -> void:
	for node in get_tree().root.get_children():
		if node.name == &"MainScene":
			main_scene = node
	for node in main_scene.get_children():
		if node.name == &"HUDOverlay":
			hud_overlay = node
	await get_tree().create_timer(.2).timeout
	DialogueManager.start_dialogue(hud_overlay, QuestManager.CharacterName.CREDITS, AudioManager.speech_sound)
