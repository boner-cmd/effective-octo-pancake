extends Node

var track_time : bool = false
var honk_counter : int = 0
var h : int
var m : int
var s : int
var time_elapsed : float
var time_string : String

func time_conversion():
	var time_int = int(time_elapsed)
	@warning_ignore_start("integer_division")
	h = int(time_int/3600)
	m = int((time_int-h)/60)
	s = time_int-(h*3600)-(m*60)
	time_string = '%02d:%02d:%02d' % [h, m, s]
	print(time_string)

func _process(delta: float) -> void:
	if track_time:
		time_elapsed += delta
