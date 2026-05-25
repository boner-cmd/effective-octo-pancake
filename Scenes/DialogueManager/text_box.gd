extends MarginContainer

@onready var label = $MarginContainer/Label
@onready var timer = $LetterDisplayTimer
@onready var audio_player = $AudioStreamPlayer
@onready var next_indicator = $NinePatchRect/Control/NextIndicator
var conf_sound : AudioStream = preload("res://sound fx exports/typewriter slide2026-05-2014_01_48.wav")

const  MAX_WIDTH = 256

var text : String = ""
var letter_index : int = 0

var letter_time : float = 0.00000001 #0.05
var space_time : float = 0.00000001 #0.08
var punctuation_time : float = 0.00000001 #0.2

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
	global_position.y -= size.y - 200
	
	label.text = ""
	_display_letter()
	
func _display_letter():
	label.text += text[letter_index]
	
	letter_index += 1
	if letter_index >= text.length():
		finished_displaying.emit()
		next_indicator.visible = true
		var conf_audio_player = audio_player.duplicate()
		get_tree().root.add_child(conf_audio_player)
		conf_audio_player.stream = conf_sound
		conf_audio_player.play()
		await conf_audio_player.finished
		conf_audio_player.queue_free()
		return
		
	match text[letter_index]:
		"!", ".", ",", "?":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)
			
			var new_audio_player = audio_player.duplicate()
			new_audio_player.pitch_scale += randf_range(-0.1, 0.1)
			if text[letter_index] in ["a", "e", "i", "o", "u"]:
				new_audio_player.pitch_scale += 0.2
			get_tree().root.add_child(new_audio_player)
			new_audio_player.play()
			await new_audio_player.finished
			new_audio_player.queue_free()

func _on_letter_display_timer_timeout() -> void:
	_display_letter()
