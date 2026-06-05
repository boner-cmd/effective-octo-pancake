extends Node3D
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var player: Node3D = $ClownRigFBX
@onready var transition_screen: ColorRect = $CanvasLayer/TransitionScreen

#pseudo for after dialoguemanager ends
func end_sequence() -> void:
	player._set_player_anim(player.AnimStates.VICTORY)
	await get_tree().create_timer(5).timeout
	
	transition_screen.visible = true
	transition_screen.self_modulate.a = 0.0
	var tween_transition = get_tree().create_tween()
	tween_transition.tween_property(transition_screen, "self_modulate:a", 1.0, 3)
	tween_transition.set_trans(Tween.TRANS_SINE)
	tween_transition.set_ease(Tween.EASE_IN)
	tween_transition.play()
	await tween_transition.finished
	transition_screen.modulate.a = 1.0
	if tween_transition and tween_transition.is_valid():
		tween_transition.kill()
	var tween_black = get_tree().create_tween()
	tween_black.tween_property(transition_screen, "self_modulate", Color(0.0, 0.0, 0.0, 1.0), 3)
	tween_black.set_trans(Tween.TRANS_SINE)
	tween_black.set_ease(Tween.EASE_OUT)
	tween_black.play()
	await tween_black.finished
	if tween_black and tween_black.is_valid():
		tween_black.kill()
	
	for node in get_tree().root.get_children():
		if node.name == "MainScene":
			node.on_planet_change_requested(0)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DialogueManager.start_dialogue(canvas_layer, QuestManager.CharacterName.CREDITS, AudioManager.speech_sound)
