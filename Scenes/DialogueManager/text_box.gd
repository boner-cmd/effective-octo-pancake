extends MarginContainer

@onready var margin_label : MarginContainer = $ControlMargin/MarginContainer
@onready var label : Label = $ControlMargin/MarginContainer/Label
@onready var timer : Timer = $LetterDisplayTimer
@onready var audio_player : AudioStreamPlayer = $AudioStreamPlayer
@onready var next_indicator : AnimatedSprite2D = $ControlIndicator/NextIndicator
@onready var next_f : Label = $ControlIndicator/NextIndicator/Label
@onready var DialogueBox : Sprite2D = $NewDialogueBoxChromakey

@onready var BaubleLeft : Sprite2D = $DialogueBaubleLeft
@onready var BaubleMiddle : Sprite2D = $DialogueBaubleMiddle
@onready var BaubleRight : Sprite2D = $DialogueBaubleRight
@onready var upper_flourish : Sprite2D = $DialogueBoxUpperFlourish

var baub_left_end_pos : Vector2 = Vector2(-360.0, 56.0)
var baub_mid_end_pos : Vector2 = Vector2(1.0, 189.0)
var baub_right_end_pos : Vector2 = Vector2(361.0, 56.0)

const  MAX_WIDTH : float = 640.0
const MAX_HEIGHT : float = 170.0

var text : String = ""
var letter_index : int = 0
var default_letter_time : float = 0.03
var letter_time : float = 0.03
var space_time : float = 0.01
var punctuation_time : float = 0.0000001

signal finished_displaying()

func tween_text_box():
	if not DialogueManager.already_tweened:
		DialogueManager.already_tweened = true
		
		DialogueBox.scale = Vector2(0.0, 0.0)
		upper_flourish.modulate.a = 0.0
		
		BaubleLeft.modulate.a = 0.0
		BaubleMiddle.modulate.a = 0.0
		BaubleRight.modulate.a = 0.0
		
		var tween_modulateL = get_tree().create_tween()
		var tween_modulateL_tweener = tween_modulateL.tween_property(BaubleLeft, "modulate:a",  1.0, .1)
		tween_modulateL_tweener.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween_modulateL.play()
		await tween_modulateL.finished
		var tween_modulateM = get_tree().create_tween()
		var tween_modulateM_tweener = tween_modulateM.tween_property(BaubleMiddle, "modulate:a",  1.0, .1)
		tween_modulateM_tweener.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween_modulateM.play()
		await tween_modulateM.finished
		var tween_modulateR = get_tree().create_tween()
		var tween_modulateR_tweener = tween_modulateR.tween_property(BaubleRight, "modulate:a",  1.0, .1)
		tween_modulateR_tweener.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween_modulateR.play()
		await tween_modulateR.finished
		
		var tween_bauble_L_pos = get_tree().create_tween()
		var tween_bauble_L_pos_tweener = tween_bauble_L_pos.tween_property(BaubleLeft, "position:x",  baub_left_end_pos.x, .2)
		tween_bauble_L_pos_tweener.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween_bauble_L_pos.play()
		
		var tween_bauble_R_pos = get_tree().create_tween()
		var tween_bauble_R_pos_tweener = tween_bauble_R_pos.tween_property(BaubleRight, "position:x", baub_right_end_pos.x, .2)
		tween_bauble_R_pos_tweener.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween_bauble_R_pos.play()
		
		var tween_x = get_tree().create_tween()
		var tween_x_tweener = tween_x.tween_property(DialogueBox, "scale:x",  1.0, .2)
		tween_x_tweener.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween_x.play()
		
		await tween_x.finished
		
		BaubleRight.modulate.a = 0.0
		BaubleLeft.modulate.a = 0.0
		
		var tween_bauble_M_pos = get_tree().create_tween()
		var tween_bauble_M_pos_tweener = tween_bauble_M_pos.tween_property(BaubleMiddle, "position:y",  baub_mid_end_pos.y, .2)
		tween_bauble_M_pos_tweener.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween_bauble_M_pos.play()
		
		var tween_y = get_tree().create_tween()
		var tween_y_tweener = tween_y.tween_property(DialogueBox, "scale:y",  1.0, .2)
		tween_y_tweener.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween_y.play()
		
		var tween_modulate_flourish = get_tree().create_tween()
		var tween_modulate_flourish_tweener = tween_modulate_flourish.tween_property(upper_flourish, "modulate:a",  1.0, .2)
		tween_modulate_flourish_tweener.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween_modulate_flourish.play()
		
		await tween_y.finished
		
		if tween_x and tween_x.is_valid():
			tween_x.kill()
		if tween_y and tween_y.is_valid():
			tween_y.kill()
		if tween_modulateL and tween_modulateL.is_valid():
			tween_modulateL.kill()
		if tween_modulateM and tween_modulateM.is_valid():
			tween_modulateM.kill()
		if tween_modulateR and tween_modulateR.is_valid():
			tween_modulateR.kill()
		if tween_bauble_L_pos and tween_bauble_L_pos.is_valid():
			tween_bauble_L_pos.kill()
		if tween_bauble_M_pos and tween_bauble_M_pos.is_valid():
			tween_bauble_M_pos.kill()
		if tween_bauble_R_pos and tween_bauble_R_pos.is_valid():
			tween_bauble_R_pos.kill()
		if tween_modulate_flourish and tween_modulate_flourish.is_valid():
			tween_modulate_flourish.kill()
		
		
	else:
		DialogueBox.scale = Vector2(1.0, 1.0)
		upper_flourish.modulate.a = 1.0
		BaubleLeft.modulate.a = 0.0
		BaubleMiddle.modulate.a = 0.0
		BaubleRight.modulate.a = 0.0
		

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
		#margin_label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	else:
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
		#margin_label.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	
	#this is to skip dialogue windows
	if Input.is_action_pressed("advance_dialogue") and letter_index > 2:
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
