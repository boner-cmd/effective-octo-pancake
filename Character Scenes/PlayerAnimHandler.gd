extends Node3D

@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"
@onready var walk_cycle_time: Timer = $"../walk_cycle_time"
@onready var honk_delay: Timer = $"../honk_delay"

const sfx_get_item = preload("uid://cp17cger7bu5p")
const sfx_give_item = preload("uid://dkwc6p8t3hdek")
const sfx_walk = preload("uid://c02mhuc0dk48x")
const sfx_jump = preload("uid://cduu2q6v1l1yk")
const sfx_explode = preload("uid://conpnqqcjln5n")
const sfx_honk = preload("uid://eqfmf8j0l8u2")

func walk_cycle_player():
	var walk_player = audio_stream_player.duplicate()
	walk_player.stream = sfx_walk
	get_tree().root.add_child(walk_player)
	walk_player.pitch_scale += randf_range(-0.05, 0.05)
	walk_player.play()
	await walk_player.finished
	walk_player.queue_free()

func explosion_sound_player():
	var explosion_player = audio_stream_player.duplicate()
	explosion_player.stream = sfx_explode
	explosion_player.volume_db -= 12.0
	get_tree().root.add_child(explosion_player)
	explosion_player.play()
	await  explosion_player.finished
	explosion_player.queue_free()
	
func jump_sound_player():
	var jump_player = audio_stream_player.duplicate()
	jump_player.stream = sfx_jump
	get_tree().root.add_child(jump_player)
	jump_player.pitch_scale += randf_range(-0.05, 0.05)
	jump_player.play()
	await jump_player.finished
	jump_player.queue_free()

func honk_sound_player():
	
	var honk_time = honk_delay.duplicate()
	var honk_player = audio_stream_player.duplicate()
	honk_player.stream = sfx_honk
	get_tree().root.add_child(honk_player)
	get_tree().root.add_child(honk_time)
	honk_time.start()
	await honk_time.timeout
	honk_player.pitch_scale += randf_range(-0.05, 0.05)
	honk_player.play()
	await honk_player.finished
	print("timerfinish")
	honk_time.queue_free()
	honk_player.queue_free()

func get_sound_player():
	var get_player = audio_stream_player.duplicate()
	get_player.stream = sfx_get_item
	get_tree().root.add_child(get_player)
	get_player.pitch_scale += randf_range(-0.05, 0.05)
	get_player.play()
	await get_player.finished
	get_player.queue_free()

func give_sound_player():
	var give_player = audio_stream_player.duplicate()
	give_player.stream = sfx_give_item
	get_tree().root.add_child(give_player)
	give_player.pitch_scale += randf_range(-0.05, 0.05)
	give_player.play()
	await give_player.finished
	give_player.queue_free()

func _on_walk_cycle_time_timeout() -> void:
	if current_anim == AnimStates.WALK:
		walk_cycle_player()

@onready var anim_tree: AnimationTree = $AnimationTree

enum AnimStates {IDLE, WALK, JUMP, GET, GIVE, TALK, VICTORY, EXIT}
var current_anim := AnimStates.IDLE

func _get_current_anim() -> AnimStates:
	return current_anim

func _set_player_anim(anim : AnimStates):
	current_anim = anim
	match current_anim:
		AnimStates.IDLE:
			anim_tree.set("parameters/Reset_Idle/seek_request", 0.0)
			
			anim_tree.set("parameters/Walk/blend_amount", 0.0)
			anim_tree.set("parameters/Exit/blend_amount", 0.0)
			anim_tree.set("parameters/Victory/blend_amount", 0.0)
			
			anim_tree.set("parameters/Talk/blend_amount", 0.0)
			anim_tree.set("parameters/Get/blend_amount", 0.0)
			anim_tree.set("parameters/Give/blend_amount", 0.0)
		AnimStates.WALK:
			anim_tree.set("parameters/Reset_Walk/seek_request", 0.0)
			
			anim_tree.set("parameters/Walk/blend_amount", 1.0)
			anim_tree.set("parameters/Exit/blend_amount", 0.0)
			anim_tree.set("parameters/Victory/blend_amount", 0.0)
			
			anim_tree.set("parameters/Talk/blend_amount", 0.0)
			anim_tree.set("parameters/Get/blend_amount", 0.0)
			anim_tree.set("parameters/Give/blend_amount", 0.0)
		AnimStates.JUMP:
			jump_sound_player()
			honk_sound_player()
			anim_tree.set("parameters/Jump/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

			anim_tree.set("parameters/Walk/blend_amount", 0.0)
			anim_tree.set("parameters/Exit/blend_amount", 0.0)
			anim_tree.set("parameters/Victory/blend_amount", 0.0)
			
			anim_tree.set("parameters/Talk/blend_amount", 0.0)
			anim_tree.set("parameters/Get/blend_amount", 0.0)
			anim_tree.set("parameters/Give/blend_amount", 0.0)
			
			
			await anim_tree.animation_finished
			_set_player_anim(AnimStates.IDLE)
		AnimStates.GET:
			get_sound_player()
			anim_tree.set("parameters/Walk/blend_amount", 0.0)
			anim_tree.set("parameters/Exit/blend_amount", 0.0)
			anim_tree.set("parameters/Victory/blend_amount", 0.0)
			
			anim_tree.set("parameters/Talk/blend_amount", 1.0)
			anim_tree.set("parameters/Get/blend_amount", 1.0)
			anim_tree.set("parameters/Give/blend_amount", 0.0)
		AnimStates.GIVE:
			give_sound_player()
			anim_tree.set("parameters/Walk/blend_amount", 0.0)
			anim_tree.set("parameters/Exit/blend_amount", 0.0)
			anim_tree.set("parameters/Victory/blend_amount", 0.0)
			
			anim_tree.set("parameters/Talk/blend_amount", 1.0)
			anim_tree.set("parameters/Get/blend_amount", 0.0)
			anim_tree.set("parameters/Give/blend_amount", 1.0)
			
		AnimStates.TALK:
			anim_tree.set("parameters/Walk/blend_amount", 0.0)
			anim_tree.set("parameters/Exit/blend_amount", 0.0)
			anim_tree.set("parameters/Victory/blend_amount", 0.0)
			
			anim_tree.set("parameters/Talk/blend_amount", 1.0)
			anim_tree.set("parameters/Get/blend_amount", 0.0)
			anim_tree.set("parameters/Give/blend_amount", 0.0)
			
		AnimStates.VICTORY:
			explosion_sound_player()
			anim_tree.set("parameters/Reset_Victory/seek_request", 0.0)
			anim_tree.set("parameters/Walk/blend_amount", 0.0)
			anim_tree.set("parameters/Exit/blend_amount", 0.0)
			anim_tree.set("parameters/Victory/blend_amount", 1.0)
			
			anim_tree.set("parameters/Talk/blend_amount", 0.0)
			anim_tree.set("parameters/Get/blend_amount", 0.0)
			anim_tree.set("parameters/Give/blend_amount", 0.0)
			
		AnimStates.EXIT:
			
			anim_tree.set("parameters/Reset_Exit/seek_request", 0.0)
			
			anim_tree.set("parameters/Walk/blend_amount", 0.0)
			anim_tree.set("parameters/Exit/blend_amount", 1.0)
			anim_tree.set("parameters/Victory/blend_amount", 0.0)
			anim_tree.set("parameters/Talk/blend_amount", 0.0)
			anim_tree.set("parameters/Get/blend_amount", 0.0)
			anim_tree.set("parameters/Give/blend_amount", 0.0)
			
			await anim_tree.animation_finished
