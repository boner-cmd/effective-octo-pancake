extends Node3D

var new_bgm_stream : AudioStreamPlayer
var current_planet_id : int = 0
# CanvasLayer is $HUDOverlay

@onready var base_bgm_stream: AudioStreamPlayer = $BGM_controller
@onready var hud_overlay: CanvasLayer = $HUDOverlay

## Current planet is used to manage planet-swapping. It is default-assigned to the first planet to
## ensure that the initial planet is removed after transition.
@onready var current_planet : Node3D = planet_nodes[0]

## TODO is default assignment required to play first planet BGM?
@onready var current_music : AudioStream = bgm_nodes[0]

## TODO convert planet_nodes to use the ResourceLoader with sub-threads
var planet_nodes : Dictionary[int, Node3D] = {
	0 : preload("res://planets/Scenes/01_Kings_Planet.tscn").instantiate(),
	1 : preload("res://planets/Scenes/02_Horse_Planet.tscn").instantiate(),
	2 : preload("res://planets/Scenes/03_Astronaut_Planet.tscn").instantiate(),
	3 : preload("res://planets/Scenes/04_Snowman_Planet.tscn").instantiate(),
	4 : preload("res://planets/Scenes/17_Sisyphus_Planet.tscn").instantiate(),
	5 : preload("res://planets/Scenes/07_GreasePuddle_Planet.tscn").instantiate(),
	6 : preload("res://planets/Scenes/10_Deer_Planet.tscn").instantiate(),
	7 : preload("res://planets/Scenes/05_Gatekeeper_Planet.tscn").instantiate(),
	8 : preload("res://planets/Scenes/09_O_Planet.tscn").instantiate(),
	9 : preload("res://planets/Scenes/15_Organs_Planet.tscn").instantiate(),
	10 : preload("res://planets/Scenes/18_Mass_Planet.tscn").instantiate(),
	11 : preload("res://planets/Scenes/12_Lamp_Planet.tscn").instantiate(),
	12 : preload("res://planets/Scenes/14_Norgans_Planet.tscn").instantiate(),
	13 : preload("res://planets/Scenes/19_Michaelwave_Planet.tscn").instantiate(),
	14 : preload("res://planets/Scenes/06_RustyRobot_Planet.tscn").instantiate(),
	15 : preload("res://planets/Scenes/13_Individual_Planet.tscn").instantiate(),
	16 : preload("res://planets/Scenes/08_Gibberish_Planet.tscn").instantiate(),
	17 : preload("res://planets/Scenes/11_Idea_Planet.tscn").instantiate(),
	18 : preload("res://planets/Scenes/16_Bodhi_Planet.tscn").instantiate(),
	19 : preload("res://planets/Scenes/20_Slime_Planet.tscn").instantiate(),
	20 : preload("res://planets/Scenes/01_Kings_Planet.tscn").instantiate(),
}

## TODO convert BGM_nodes to use the ResourceLoader with sub-threads
var bgm_nodes : Dictionary[int, AudioStream] = {
	0 : preload("res://music exports/king2026-05-2113_23_05.wav"),
	1 : preload("res://music exports/horse2026-05-2217_28_31.wav"),
	2 : preload("res://music exports/astronaut2026-05-2115_37_01.wav"),
	3 : preload("res://music exports/snowman2026-05-2116_16_58.wav"),
	4 : preload("res://music exports/sisyphus2026-05-2217_25_08.wav"),
	5 : preload("res://music exports/grease2026-05-2323_27_38.wav"),
	6 : preload("res://music exports/no-eye'd deer2026-05-2121_27_03.wav"),
	7 : preload("res://music exports/gatekeeper2026-05-2217_34_46.wav"),
	8 : preload("res://music exports/o2026-05-2322_20_48.wav"),
	9 : preload("res://music exports/body with organs2026-05-2216_17_11.wav"),
	10 : preload("res://music exports/festering mass2026-05-2220_52_41.wav"),
	11 : preload("res://music exports/lamp2026-05-2222_01_50.wav"),
	12 : preload("res://music exports/body without organs2026-05-2323_48_46.wav"),
	13 : preload("res://music exports/astronaut2026-05-2115_37_01.wav"), # TODO Michaelwave placeholder
	14 : preload("res://music exports/robot2026-05-2119_52_12.wav"),
	15 : preload("res://music exports/individuated individual2026-05-2121_51_23.wav"),
	16 : preload("res://music exports/gibberish2026-05-2121_42_44.wav"),
	17 : preload("res://music exports/idea guy2026-05-2122_27_19.wav"),
	18 : preload("res://music exports/boddhisattva2026-05-2221_27_06.wav"),
	19 : preload("res://music exports/slime mould2026-05-2219_04_13.wav"),
	20 : preload("res://music exports/king2026-05-2113_23_05.wav"),
}

## TODO switch to a Dictionary to have different voices per character
#@onready var speech_sound = preload("res://sound fx exports/typewriter2026-05-20_13_26_04.wav")

## TODO placeholder documentation
func _ready() -> void:
	
	
	# TODO verify the below comment
	# music code doesn't work yet
	new_bgm_stream = base_bgm_stream.duplicate()
	new_bgm_stream.stream = bgm_nodes[0]
	get_tree().root.add_child(new_bgm_stream)
	new_bgm_stream.play()
	
	# initial setup for first planet, door, and bgm
	get_tree().root.add_child(planet_nodes[0]) 
	var initial_door : Node3D = get_tree().get_nodes_in_group("Door_Base").front()
	initial_door.request_planet_change.connect(on_planet_change_requested)
	initial_door.request_music_change.connect(_bgm_track_cycle)

func _bgm_track_cycle(planet : QuestManager.CharacterName):
#	fade out old stream
	var tween_old = get_tree().create_tween()
	tween_old.tween_property(new_bgm_stream, "volume_linear", 0.0, .5) 
	await tween_old.finished
	new_bgm_stream = base_bgm_stream.duplicate()
	new_bgm_stream.stream = bgm_nodes[planet]
	get_tree().root.add_child(new_bgm_stream)
	new_bgm_stream.play()

## TODO delete this function if unused
func _new_track_start():
	pass


## TODO delete this function if unused
func on_playerExit_anim_start():
	pass


## TODO placeholder documentation
func on_planet_change_requested(character : QuestManager.CharacterName):
	current_planet_id = character
	var requested_planet = planet_nodes[character]
	var requested_bgm = bgm_nodes[character]
	requested_planet.request_ready() # required to re-roll object locations on planet
	
	hud_overlay.transition_hard_in()
	get_tree().root.add_child(requested_planet)
	get_tree().root.remove_child(current_planet)
	
	# swap over planet and music
	current_planet = requested_planet
	current_music = requested_bgm
	
	_bgm_track_cycle(character)
	
	# try to connect new door and bgm signals, whether required or not
	for door in get_tree().get_nodes_in_group("Door_Base"):
		if !door.request_planet_change.is_connected(on_planet_change_requested):
			door.request_planet_change.connect(on_planet_change_requested)
		if !door.request_music_change.is_connected(_bgm_track_cycle):	
			door.request_music_change.connect(_bgm_track_cycle)
	
	$PlayerCharacter.reset_player()
