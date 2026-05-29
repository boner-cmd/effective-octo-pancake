extends Node

#timers
var honk_timer : Timer
var letter_timer : Timer
var walk_cycle_timer : Timer

#AudioStreamPlayers
var SFX_Player : AudioStreamPlayer
var BGM_Player : AudioStreamPlayer
var temp_BGM_Player : AudioStreamPlayer

#BGM
const BGM_nodes : Dictionary[int, AudioStream] = {
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
	21 : preload("res://music exports/valhalla2026-05-2717_11_57.wav"), #title
}

#SFX player
const sfx_get_item : AudioStream = preload("uid://cp17cger7bu5p")
const sfx_give_item : AudioStream = preload("uid://dkwc6p8t3hdek")
const sfx_walk : AudioStream = preload("uid://c02mhuc0dk48x")
const sfx_jump : AudioStream = preload("uid://cduu2q6v1l1yk")
const sfx_explode : AudioStream = preload("uid://conpnqqcjln5n")
const sfx_honk : AudioStream = preload("uid://eqfmf8j0l8u2")
#SFX door
const sfx_despawn : AudioStream = preload("uid://7banle6yv2gq")
const sfx_spawn : AudioStream = preload("uid://t6h5ww03rkm7")
const sfx_exit : AudioStream = preload("uid://dklltp1vyr8pp")
#Misc SFX
const sfx_blip : AudioStream = preload("res://sound fx exports/menu choice blip2026-05-2222_33_19.wav")



#speech sounds
const speech_sound : AudioStream = preload("res://sound fx exports/typewriter2026-05-20_13_26_04.wav")
const conf_sound : AudioStream = preload("res://sound fx exports/typewriter slide2026-05-2014_01_48.wav")

func sfx_play(sfx : AudioStream, pitch_range: float = randf_range(-0.1, 0.1)):
	var Temp_SFX_Player = SFX_Player.duplicate()
	Temp_SFX_Player.stream = sfx
	get_tree().root.add_child.call_deferred(Temp_SFX_Player)
	await Temp_SFX_Player.tree_entered
	if sfx == sfx_explode:
			Temp_SFX_Player.volume_db -= 12.0
	Temp_SFX_Player.pitch_scale += pitch_range
	Temp_SFX_Player.play()
	await Temp_SFX_Player.finished
	Temp_SFX_Player.queue_free()

#BGM cycle
func bgm_cycle(planetID: int):
	var tween_old = get_tree().create_tween()
	tween_old.tween_property(temp_BGM_Player, "volume_linear", 0.0, .5)
	await tween_old.finished
	temp_BGM_Player.queue_free()
	
	temp_BGM_Player = BGM_Player.duplicate()
	temp_BGM_Player.stream = BGM_nodes[planetID]
	get_tree().root.add_child(temp_BGM_Player)
	temp_BGM_Player.play()


func _ready() -> void:
	var tree = get_tree().get_root()
	
	SFX_Player = AudioStreamPlayer.new()
	SFX_Player.bus = "Sfx"
	SFX_Player.autoplay = true
	tree.add_child.call_deferred(SFX_Player)
	
	BGM_Player = AudioStreamPlayer.new()
	BGM_Player.bus = "Music"
	BGM_Player.autoplay = true
	tree.add_child.call_deferred(BGM_Player)
	
	temp_BGM_Player = BGM_Player.duplicate()
	temp_BGM_Player.stream = BGM_nodes[21]
	get_tree().root.add_child.call_deferred(temp_BGM_Player)
	await temp_BGM_Player.tree_entered
	temp_BGM_Player.play()
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
