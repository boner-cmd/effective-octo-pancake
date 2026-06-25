extends MarginContainer

const  MAX_WIDTH : float = 640.0
const MAX_HEIGHT : float = 170.0

var baub_left_end_pos : Vector2 = Vector2(-360.0, 56.0)
var baub_mid_end_pos : Vector2 = Vector2(1.0, 183.0)
var baub_right_end_pos : Vector2 = Vector2(361.0, 56.0)

var text : String = ""
var letter_index : int = 0
var default_letter_time : float = 0.03
var letter_time : float = 0.03
var space_time : float = 0.01
var punctuation_time : float = 0.0000001

@onready var margin_label : MarginContainer = $ControlMargin/MarginContainer
@onready var label : Label = $ControlMargin/MarginContainer/Label
@onready var timer : Timer = $LetterDisplayTimer
@onready var audio_player : AudioStreamPlayer = $AudioStreamPlayer
@onready var next_indicator : AnimatedSprite2D = $ControlIndicator/NextIndicator
@onready var next_f : Label = $ControlIndicator/NextIndicator/Label
@onready var DialogueBox : Sprite2D = $DialogueBox5

@onready var BaubleLeft : Sprite2D = $DialogueBaubleLeft
@onready var BaubleMiddle : Sprite2D = $DialogueBaubleMiddle
@onready var BaubleRight : Sprite2D = $DialogueBaubleRight

signal finished_displaying()


func tween_text_box():
	if not DialogueManager.already_tweened:
		DialogueManager.already_tweened = true
		DialogueBox.scale = Vector2(0.001, 0.001)
		BaubleLeft.modulate.a = 0.0
		BaubleMiddle.modulate.a = 0.0
		BaubleRight.modulate.a = 0.0
		
		await tween_object(BaubleLeft, "modulate:a",  1.0, .1, Tween.TRANS_SINE, Tween.EASE_OUT)
		await get_tree().create_timer(.05).timeout
		await tween_object(BaubleMiddle, "modulate:a",  1.0, .1, Tween.TRANS_SINE, Tween.EASE_OUT)
		await get_tree().create_timer(.05).timeout
		await tween_object(BaubleRight, "modulate:a",  1.0, .1, Tween.TRANS_SINE, Tween.EASE_OUT)
		await get_tree().create_timer(.05).timeout
		tween_object(BaubleLeft, "position:x",  baub_left_end_pos.x, .2, Tween.TRANS_SINE, Tween.EASE_OUT)
		tween_object(BaubleRight, "position:x", baub_right_end_pos.x, .2, Tween.TRANS_SINE, Tween.EASE_OUT)
		await tween_object(DialogueBox, "scale:x",  1.0, .2, Tween.TRANS_SINE, Tween.EASE_OUT)
		
		BaubleRight.modulate.a = 1.0
		BaubleLeft.modulate.a = 1.0
		
		tween_object(BaubleMiddle, "position:y",  baub_mid_end_pos.y, .2, Tween.TRANS_SINE, Tween.EASE_OUT)
		await tween_object(DialogueBox, "scale:y",  1.0, .2, Tween.TRANS_SINE, Tween.EASE_OUT)
		await get_tree().create_timer(.1).timeout
	else:
		DialogueBox.scale = Vector2(1.0, 1.0)
		BaubleLeft.position = baub_left_end_pos
		BaubleMiddle.position = baub_mid_end_pos
		BaubleRight.position = baub_right_end_pos


func close_text_box() -> void:
	BaubleRight.modulate.a = 1.0
	BaubleLeft.modulate.a = 1.0
	BaubleMiddle.modulate.a = 1.0
	
	BaubleLeft.position = baub_left_end_pos
	BaubleMiddle.position = baub_mid_end_pos
	BaubleRight.position = baub_right_end_pos
	
	next_indicator.visible = false
	label.visible = false
	
	tween_object(DialogueBox, "scale:y",  0.001, .2, Tween.TRANS_SINE, Tween.EASE_IN)
	await tween_object(BaubleMiddle, "position:y",  56.0, .2, Tween.TRANS_SINE, Tween.EASE_IN)
	await get_tree().create_timer(.1).timeout
	tween_object(BaubleLeft, "position:x",  -32.0, .2, Tween.TRANS_SINE, Tween.EASE_IN)
	tween_object(BaubleRight, "position:x", 32.0, .2, Tween.TRANS_SINE, Tween.EASE_IN)
	tween_object(DialogueBox, "scale:x", 1.0, .2, Tween.TRANS_SINE, Tween.EASE_IN)


func display_text(text_to_display: String, speech_sfx: AudioStream):
	text = text_to_display
	label.text = text_to_display
	audio_player.stream = speech_sfx
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	custom_minimum_size.y = size.y
	label.text = ""
	await tween_text_box()
	_display_letter()


func _display_letter():
	label.text += text[letter_index]
	if text.length() < 50:
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	else:
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	#this is to skip dialogue windows
	if Input.is_action_pressed("advance_dialogue") and letter_index > 10:
		for Letters in letter_index:
			text.erase(Letters)
		label.text = text
		letter_index = text.length() -1
		
	letter_index += 1
	if letter_index >= text.length():
		finished_displaying.emit()
		next_indicator.visible = true
		next_indicator.play()
		await next_indicator.animation_finished
		next_f.visible = true
		AudioManager.sfx_play(AudioManager.sfx_blip, 1.0)
		return
		
	match text[letter_index]:
		"!", ".", ",", "?":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)
			
			if text[letter_index] in ["a", "e", "i", "o", "u"]:
				AudioManager.sfx_play(AudioManager.speech_sound, .2)
			AudioManager.sfx_play(AudioManager.speech_sound, randf_range(-0.1, 0.1))


func _on_letter_display_timer_timeout() -> void:
	_display_letter()


func tween_object(object : Object, property : NodePath, goal : Variant, time : float, 
			transtype : Tween.TransitionType, easetype : Tween.EaseType) -> Signal:

	var tweened_object = get_tree().create_tween()
	var tweener_object = tweened_object.tween_property(object, property, goal, time).from_current()
	tweener_object.set_trans(transtype).set_ease(easetype)
	tweened_object.play()
	await tweened_object.finished
	if tweened_object and tweened_object.is_valid():
		tweened_object.kill()
	return tweened_object.finished
