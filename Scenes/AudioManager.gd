extends Node

#BGM
const BGM_nodes : Dictionary[int, AudioStream] = {
	0 : preload("res://music exports/king.wav"),
	1 : preload("res://music exports/horse.wav"),
	2 : preload("res://music exports/astronaut.wav"),
	3 : preload("res://music exports/snowman.wav"),
	4 : preload("res://music exports/sisyphus.wav"),
	5 : preload("res://music exports/grease.wav"),
	6 : preload("res://music exports/no-eye'd deer2026-05-2121_27_03.wav"), #good
	7 : preload("res://music exports/gatekeeper.wav"),
	8 : preload("res://music exports/o.wav"),
	9 : null,#preload("res://music exports/body with organs2026-05-2216_17_11.wav"),
	10 : preload("res://music exports/festering mass.wav"),
	11 : preload("res://music exports/lamp2026-05-2222_01_50.wav"),
	12 : preload("res://music exports/body without organs.wav"),
	13 : preload("res://music exports/michaelwave.wav"),
	14 : preload("res://music exports/robot.wav"),
	15 : preload("res://music exports/individuated individual.wav"),
	16 : preload("res://music exports/gibberish.wav"),
	17 : preload("res://music exports/idea guy.wav"),
	18 : preload("res://music exports/boddhisattva.wav"),
	19 : preload("res://music exports/slime mould.wav"),
	20 : preload("res://music exports/king.wav"),
	21 : preload("res://music exports/void2.wav"),
	22 : preload("res://music exports/title screen proper.wav"), #title
}

const BORGANS_A = preload("uid://ckbl50xceswh4")
const BORGANS_B = preload("uid://0g3q3xrr6h8i")
const BORGANS_C = preload("uid://bv1cruevybdiu")
const BORGANS_D = preload("uid://cjxw8phi4jpe")
const BORGANS_E = preload("uid://dvudjpilu4kkf")
const BORGANS_F = preload("uid://cys3kix6r1d62")
const BORGANS_G = preload("uid://dkelsetuy76ok")

#SFX player
const sfx_get_item : AudioStream = preload("uid://cp17cger7bu5p")
const sfx_give_item : AudioStream = preload("uid://dkwc6p8t3hdek")
const sfx_walk : AudioStream = preload("uid://c02mhuc0dk48x")
const sfx_jump : AudioStream = preload("uid://cduu2q6v1l1yk")
const sfx_explode : AudioStream = preload("uid://conpnqqcjln5n")
const sfx_honk : AudioStream = preload("uid://eqfmf8j0l8u2")
const sfx_sadhonk : AudioStream = preload("res://sound fx exports/sadhonk.wav")

#SFX door
const sfx_despawn : AudioStream = preload("uid://7banle6yv2gq")
const sfx_spawn : AudioStream = preload("uid://t6h5ww03rkm7")
const sfx_exit : AudioStream = preload("uid://dklltp1vyr8pp")

#Misc SFX
const sfx_blip : AudioStream = preload("res://sound fx exports/menu choice blip2026-05-2222_33_19.wav")

#speech sounds
const speech_sound : AudioStream = preload("res://sound fx exports/typewriter2026-05-20_13_26_04.wav")
const conf_sound : AudioStream = preload("res://sound fx exports/typewriter slide2026-05-2014_01_48.wav")


var BORGANS_BOOL : bool = false
var BORGANS_PLAYER_A : AudioStreamPlayer
var BORGANS_PLAYER_B : AudioStreamPlayer
var BORGANS_PLAYER_C : AudioStreamPlayer
var BORGANS_PLAYER_D : AudioStreamPlayer
var BORGANS_PLAYER_E : AudioStreamPlayer
var BORGANS_PLAYER_F : AudioStreamPlayer
var BORGANS_PLAYER_G : AudioStreamPlayer

#timers
var honk_timer : Timer
var letter_timer : Timer
var walk_cycle_timer : Timer

#AudioStreamPlayers
var SFX_Player : AudioStreamPlayer
var BGM_Player : AudioStreamPlayer
var temp_BGM_Player : AudioStreamPlayer


func _ready() -> void:
	var tree = get_tree().get_root()
	
	SFX_Player = AudioStreamPlayer.new()
	SFX_Player.process_mode = PROCESS_MODE_ALWAYS
	SFX_Player.bus = "Sfx"
	SFX_Player.autoplay = true
	tree.add_child.call_deferred(SFX_Player)
	
	BGM_Player = AudioStreamPlayer.new()
	BGM_Player.bus = "Music"
	BGM_Player.autoplay = true
	BGM_Player.process_mode = PROCESS_MODE_ALWAYS
	tree.add_child.call_deferred(BGM_Player)
	
	temp_BGM_Player = BGM_Player.duplicate()
	temp_BGM_Player.stream = BGM_nodes[22]
	get_tree().root.add_child.call_deferred(temp_BGM_Player)
	temp_BGM_Player.process_mode = PROCESS_MODE_ALWAYS
	await temp_BGM_Player.tree_entered
	temp_BGM_Player.play()


func sfx_play(sfx : AudioStream, pitch_range: float = randf_range(-0.1, 0.1)):
	var Temp_SFX_Player = SFX_Player.duplicate()
	Temp_SFX_Player.stream = sfx
	get_tree().root.add_child.call_deferred(Temp_SFX_Player)
	await Temp_SFX_Player.tree_entered
	if sfx == sfx_explode:
			Temp_SFX_Player.volume_db -= 12.0
	if sfx == sfx_blip:
			Temp_SFX_Player.volume_db += 18
	Temp_SFX_Player.pitch_scale += pitch_range
	Temp_SFX_Player.play()
	#HonkCounter.add_honk()
	await Temp_SFX_Player.finished
	Temp_SFX_Player.queue_free()


##BGM cycle
func bgm_cycle(planetID: int):
	if planetID != 9:
		if BORGANS_BOOL:
			var tween_A = get_tree().create_tween()
			var tween_B = get_tree().create_tween()
			var tween_C = get_tree().create_tween()
			var tween_D = get_tree().create_tween()
			var tween_E = get_tree().create_tween()
			var tween_F = get_tree().create_tween()
			var tween_G = get_tree().create_tween()
			tween_A.tween_property(BORGANS_PLAYER_A, "volume_linear", 0.0, .7)
			tween_B.tween_property(BORGANS_PLAYER_B, "volume_linear", 0.0, .7)
			tween_C.tween_property(BORGANS_PLAYER_C, "volume_linear", 0.0, .7)
			tween_D.tween_property(BORGANS_PLAYER_D, "volume_linear", 0.0, .7)
			tween_E.tween_property(BORGANS_PLAYER_E, "volume_linear", 0.0, .7)
			tween_F.tween_property(BORGANS_PLAYER_F, "volume_linear", 0.0, .7)
			tween_G.tween_property(BORGANS_PLAYER_G, "volume_linear", 0.0, .7)
			tween_A.play()
			tween_B.play()
			tween_C.play()
			tween_D.play()
			tween_E.play()
			tween_F.play()
			tween_G.play()
			await tween_G.finished
			BORGANS_PLAYER_A.stream = null
			BORGANS_PLAYER_B.stream = null
			BORGANS_PLAYER_C.stream = null
			BORGANS_PLAYER_D.stream = null
			BORGANS_PLAYER_E.stream = null
			BORGANS_PLAYER_F.stream = null
			BORGANS_PLAYER_G.stream = null
			BORGANS_BOOL = false
		else:
			var tween_old = get_tree().create_tween()
			tween_old.tween_property(temp_BGM_Player, "volume_linear", 0.0, .7)
			tween_old.play()
			await tween_old.finished
			temp_BGM_Player.queue_free()
		temp_BGM_Player = BGM_Player.duplicate()
		temp_BGM_Player.stream = BGM_nodes[planetID]
		get_tree().root.add_child(temp_BGM_Player)
	if planetID == 21:
		temp_BGM_Player.volume_db = 5.0
	if temp_BGM_Player:
		temp_BGM_Player.play()
	if planetID == 9:
		BORGANS_BOOL = true
		temp_BGM_Player.queue_free()
		BORGANS_PLAYER_A = BGM_Player.duplicate()
		BORGANS_PLAYER_B = BGM_Player.duplicate()
		BORGANS_PLAYER_C = BGM_Player.duplicate()
		BORGANS_PLAYER_D = BGM_Player.duplicate()
		BORGANS_PLAYER_E = BGM_Player.duplicate()
		BORGANS_PLAYER_F = BGM_Player.duplicate()
		BORGANS_PLAYER_G = BGM_Player.duplicate()
		BORGANS_PLAYER_A.stream = BORGANS_A
		BORGANS_PLAYER_B.stream = BORGANS_B
		BORGANS_PLAYER_C.stream = BORGANS_C
		BORGANS_PLAYER_D.stream = BORGANS_D
		BORGANS_PLAYER_E.stream = BORGANS_E
		BORGANS_PLAYER_F.stream = BORGANS_F
		BORGANS_PLAYER_G.stream = BORGANS_G
		get_tree().root.add_child(BORGANS_PLAYER_A)
		get_tree().root.add_child(BORGANS_PLAYER_B)
		get_tree().root.add_child(BORGANS_PLAYER_C)
		get_tree().root.add_child(BORGANS_PLAYER_D)
		get_tree().root.add_child(BORGANS_PLAYER_E)
		get_tree().root.add_child(BORGANS_PLAYER_F)
		get_tree().root.add_child(BORGANS_PLAYER_G)
		BORGANS_PLAYER_A.play()
		BORGANS_PLAYER_B.play()
		BORGANS_PLAYER_C.play()
		BORGANS_PLAYER_D.play()
		BORGANS_PLAYER_E.play()
		BORGANS_PLAYER_F.play()
		BORGANS_PLAYER_G.play()
