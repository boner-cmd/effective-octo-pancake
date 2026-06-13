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
		DialogueBox.scale = Vector2(0.0, 0.0)
		DialogueManager.already_tweened = true
		var tween_x = get_tree().create_tween()
		var tween_y = get_tree().create_tween()
		
		var tween_x_tweener = tween_x.tween_property(DialogueBox, "scale:x",  1.0, .3)
		tween_x_tweener.set_trans(Tween.TRANS_SINE)
		tween_x_tweener.set_ease(Tween.EASE_OUT)
		tween_x.play()
		
		#var tween_pos_x_tweener = tween_pos_x.tween_property(self, "position:x", 320.0, .2)
		#tween_pos_x_tweener.set_trans(Tween.TRANS_SINE)
		#tween_pos_x_tweener.set_ease(Tween.EASE_OUT)
		#tween_pos_x.play()
		
		var tween_y_tweener = tween_y.tween_property(DialogueBox, "scale:y",  1.0, .3).set_delay(.1)
		tween_y_tweener.set_trans(Tween.TRANS_SINE)
		tween_y_tweener.set_ease(Tween.EASE_OUT)
		tween_y.play()
		await tween_y.finished
		if tween_x and tween_x.is_valid():
			tween_x.kill()
		if tween_y and tween_y.is_valid():
			tween_y.kill()
		#if tween_pos_x and tween_pos_x.is_valid():
			#tween_pos_x.kill()
	else:
		DialogueBox.scale = Vector2(1.0, 1.0)

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
