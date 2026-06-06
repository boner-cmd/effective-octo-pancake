extends Node3D
@onready var player: Node3D = $ClownRigFBX
var transition_screen: ColorRect
var hud_overlay : CanvasLayer
var main_scene : Node3D

#pseudo for after dialoguemanager ends
func end_sequence() -> void:
	transition_screen.self_modulate = Color(1.0, 1.0, 1.0, 0.0)
	player._set_player_anim(player.AnimStates.VICTORY)
	await get_tree().create_timer(3).timeout
	transition_screen.visible = true
	var tween_transition = get_tree().create_tween()
	tween_transition.tween_property(transition_screen, "self_modulate", Color(1.0, 1.0, 1.0, 1.0), 3.0)
	tween_transition.set_trans(Tween.TRANS_SINE)
	tween_transition.set_ease(Tween.EASE_IN)
	tween_transition.play()
	await tween_transition.finished
	transition_screen.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	if tween_transition and tween_transition.is_valid():
		tween_transition.kill()
	await get_tree().create_timer(3).timeout
	var tween_black = get_tree().create_tween()
	tween_black.tween_property(transition_screen, "self_modulate", Color(0.0, 0.0, 0.0, 1.0), 2.0)
	tween_black.set_trans(Tween.TRANS_SINE)
	tween_black.set_ease(Tween.EASE_OUT)
	
	tween_black.play()
	await tween_black.finished
	transition_screen.self_modulate = Color(0.0, 0.0, 0.0, 1.0)
	if tween_black and tween_black.is_valid():
		tween_black.kill()
	await get_tree().create_timer(2).timeout
	transition_screen.visible = false

	for node in get_tree().root.get_children():
		if node.name == "MainScene":
			main_scene = node
	main_scene.on_planet_change_requested(0)
	transition_screen.visible = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in get_tree().root.get_children():
		if node.name == "MainScene":
			hud_overlay = node.get_child(0)
	transition_screen = hud_overlay.get_child(4)
	transition_screen.self_modulate = Color(1.0, 1.0, 1.0, 0.0)
	await get_tree().create_timer(.2).timeout
	print("sending to dialogue manager")
	DialogueManager.start_dialogue(hud_overlay, QuestManager.CharacterName.CREDITS, AudioManager.speech_sound)
