extends MarginContainer

@onready var label = $MarginContainer/Label
@onready var timer = $LetterDisplayTimer
@onready var audio_player = $AudioStreamPlayer
@onready var next_indicator = $NinePatchRect/Control/NextIndicator

const  MAX_WIDTH = 512

var text : String = ""
var letter_index : int = 0
var default_letter_time : float = .02
var letter_time : float = 0.05
var space_time : float = 0.01
var punctuation_time : float = 0.0000001

signal finished_displaying()

func display_text(text_to_display: String, speech_sfx: AudioStream):
	text = text_to_display
	label.text = text_to_display
	audio_player.stream = speech_sfx
	
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized # wait for x to size
		await resized # wait for y to size
		custom_minimum_size.y = size.y
	
	#global_position.x -= size.x / 2
	#global_position.y -= size.y - 200
	
	label.text = ""
	
	
	_display_letter()
	
func _display_letter():
	label.text += text[letter_index]
	
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
