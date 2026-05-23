extends Node3D

@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"
const sfx_despawn = preload("uid://7banle6yv2gq")
const sfx_spawn = preload("uid://t6h5ww03rkm7")
const sfx_exit = preload("uid://dklltp1vyr8pp")

@onready var anim_tree: AnimationTree = $AnimationTree
@onready var player_exit_position: Node3D = $"../PlayerAnimationPosition"

enum AnimStates {IDLE, STASIS, SPAWN, DESPAWN, EXIT}

var current_anim := AnimStates.STASIS

func _set_door_anim(anim : AnimStates):
	current_anim = anim
	match current_anim:
		AnimStates.STASIS:
			anim_tree.set("parameters/Door_Active/blend_amount", 0.0)
			
		AnimStates.SPAWN:
			spawn_sound_player()
			anim_tree.set("parameters/Reset_DoorSpawn/seek_request", 0.0)
			anim_tree.set("parameters/DoorSpawnTimescale/scale", 2.0)
			anim_tree.set("parameters/Door_Active/blend_amount", 1.0)
			await anim_tree.animation_finished
			_set_door_anim(AnimStates.IDLE)
			
		AnimStates.IDLE:
			anim_tree.set("parameters/DoorIdle_Reset/seek_request", 0.0)
			anim_tree.set("parameters/Door_Idle/blend_amount", 0.0)

		AnimStates.DESPAWN:
			despawn_sound_player()
			anim_tree.set("parameters/Door_Idle/blend_amount", 1.0)
			anim_tree.set("parameters/Reset_DoorSpawn/seek_request", 1.0)
			anim_tree.set("parameters/DoorSpawnTimescale/scale", -2.0)
			
		AnimStates.EXIT:
			exit_sound_player()
			exit_anim_started.emit()
			anim_tree.set("parameters/Reset_DoorExit/seek_request", 0.0)
			anim_tree.set("parameters/DoorExit/blend_amount", 1.0)
			await anim_tree.animation_finished
			exit_anim_finished.emit()
			_set_door_anim(AnimStates.STASIS)

func _ready() -> void:
	_set_door_anim(AnimStates.STASIS)

signal exit_anim_finished
signal exit_anim_started

func spawn():
	_set_door_anim(AnimStates.SPAWN)

func despawn():
	_set_door_anim(AnimStates.DESPAWN)

func _on_door_spawn_radius_area_entered(_area: Area3D) -> void:
	print("entered")
	_set_door_anim(AnimStates.SPAWN)

func _on_door_spawn_radius_area_exited(_area: Area3D) -> void:
	_set_door_anim(AnimStates.DESPAWN)

func spawn_sound_player():
	var spawn_player = audio_stream_player.duplicate()
	spawn_player.stream = sfx_spawn
	get_tree().root.add_child(spawn_player)
	spawn_player.pitch_scale += randf_range(-0.1, 0.1)
	spawn_player.play()
	await spawn_player.finished
	spawn_player.queue_free()
	
func despawn_sound_player():
	var despawn_player = audio_stream_player.duplicate()
	despawn_player.stream = sfx_despawn
	get_tree().root.call_deferred("add_child", despawn_player)
	despawn_player.pitch_scale += randf_range(-0.1, 0.1)
	despawn_player.play()
	await despawn_player.finished
	despawn_player.queue_free()
	
func exit_sound_player():
	var exit_player = audio_stream_player.duplicate()
	exit_player.stream = sfx_exit
	get_tree().root.add_child(exit_player)
	exit_player.play()
	await exit_player.finished
	exit_player.queue_free()
	
func interact(player : CharacterBody3D):
	player.FUCKOFF = true
	var rig = player.get_child(2)
	var clone = rig.duplicate()
	get_tree().root.add_child(clone)
	rig.visible = false
	rig._set_player_anim(rig.AnimStates.IDLE)
	clone.global_position = player_exit_position.global_position
	clone.global_rotation = player_exit_position.global_rotation
	clone._set_player_anim(clone.AnimStates.EXIT)
	
	_set_door_anim(AnimStates.EXIT)
	
	
