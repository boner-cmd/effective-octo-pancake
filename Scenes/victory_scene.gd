extends Node3D
@onready var player: Node3D = $ClownRigFBX
var transition_screen_black: ColorRect
var transition_screen_white: ColorRect
var hud_overlay : CanvasLayer
var main_scene : Node3D
var dialogue_vignette


func end_sequence() -> void:
	player._set_player_anim(player.AnimStates.VICTORY)
	await get_tree().create_timer(3.0).timeout
	await tween_object(transition_screen_white, "modulate:a", 1.0, 2.0, Tween.TRANS_SINE, Tween.EASE_IN)
	await get_tree().create_timer(3.0).timeout
	transition_screen_black.visible = true
	transition_screen_black.modulate.a = 1.0
	await get_tree().create_timer(3.0).timeout
	await tween_object(transition_screen_white, "modulate:a", 0.0, 2.0, Tween.TRANS_SINE, Tween.EASE_OUT)
	await get_tree().create_timer(3.0).timeout
	main_scene.on_planet_change_requested(0)


func _ready() -> void:
	for node in get_tree().root.get_children():
		if node.name == &"MainScene":
			main_scene = node
		if node.name == &"TransitionSceneOverlay":
			transition_screen_black = node.get_child(0)
			transition_screen_white = node.get_child(1)
	for node in main_scene.get_children():
		if node.name == &"HUDOverlay":
			hud_overlay = node
	await get_tree().create_timer(.2).timeout
	DialogueManager.start_dialogue(hud_overlay, QuestManager.CharacterName.CREDITS, AudioManager.speech_sound)
	transition_screen_white.modulate.a = 0.0
	transition_screen_white.visible = true


func tween_object(object : Object, property : NodePath, goal : Variant, time : float, 
			transtype : Tween.TransitionType, easetype : Tween.EaseType) -> void:
	var tweened_object = get_tree().create_tween()
	tweened_object.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	var tweener_object = tweened_object.tween_property(object, property, goal, time).from_current()
	tweener_object.set_trans(transtype).set_ease(easetype)
	tweened_object.play()
	await tweened_object.finished
	if tweened_object and tweened_object.is_valid():
		tweened_object.kill()
