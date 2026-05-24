extends Node3D
var player: CharacterBody3D
@onready var main_ : Node3D
@export var destination_planet_ID : int
@onready var door_skele: Node3D = $DoorAnims
@onready var door_mesh: MeshInstance3D = $DoorAnims/Skeleton3D/Door
var door_mats : Dictionary[int, Material] = {
	1 : preload("res://planets/materials/01_kings_planet_mat.tres"),
	2 : preload("res://planets/materials/02_horse_planet.tres"),
	3 : preload("res://planets/materials/03_astronaut_planet.tres"),
	4 : preload("res://planets/materials/04_snowman_planet.tres"),
	5 : preload("res://planets/materials/05_gatekeeper_planet.tres"),
	6 : preload("res://planets/materials/06_rusty_planet.tres"),
	7 : preload("res://planets/materials/07_grease_planet.tres"),
	8 : preload("res://planets/materials/08_gibberish_planet.tres"),
	9 : preload("res://planets/materials/09_O_planet.tres"),
	10 : preload("res://planets/materials/10_Deer_planet.tres"),
	11 : preload("res://planets/materials/11_Idea_planet.tres"),
	12 : preload("res://planets/materials/12_Lamp_planet.tres"),
	13 : preload("res://planets/materials/13_Individual_planet.tres"),
	14 : null,
	15 : preload("res://planets/materials/15_Organs_planet.tres"),
	16 : preload("res://planets/materials/16_Bodhi_planet.tres"),
	17 : preload("res://planets/materials/17_Sisyphus_planet.tres"),
	18 : preload("res://planets/materials/18_Mass_planet.tres"),
	19 : preload("res://planets/materials/19_Michaelwave_planet.tres"),
	20 : preload("res://planets/materials/20_Slime_planet.tres"),
}



@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"
const sfx_despawn = preload("uid://7banle6yv2gq")
const sfx_spawn = preload("uid://t6h5ww03rkm7")
const sfx_exit = preload("uid://dklltp1vyr8pp")

@onready var anim_tree: AnimationTree = $AnimationTree
@onready var player_exit_position: Node3D = $"../PlayerAnimationPosition"


var door_locked : bool = false

enum AnimStates {IDLE, STASIS, SPAWN, DESPAWN, EXIT}

var current_anim := AnimStates.STASIS

func _set_door_anim(anim : AnimStates):
	current_anim = anim
	if !door_locked:
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
	else:
		#maybe need some weird animation state for polish
		pass

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	_set_door_anim(AnimStates.STASIS)
	main_ = get_tree().get_root().get_node("MainScene")
	door_mesh.set_surface_override_material(0, door_mats[destination_planet_ID])

signal exit_anim_finished
signal exit_anim_started

func spawn():
	_set_door_anim(AnimStates.SPAWN)

func despawn():
	_set_door_anim(AnimStates.DESPAWN)

func _on_door_spawn_radius_area_entered(_area: Area3D) -> void:
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
	get_tree().root.add_child(despawn_player)
	print("despawn sound player")
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
	
func interact():
	request_music_change.emit()
	player.exit_check = true
	var rig = player.get_child(2)
	var clone = rig.duplicate()
	get_tree().root.add_child(clone)
	rig.visible = false
	rig._set_player_anim(rig.AnimStates.IDLE)
	clone.global_position = player_exit_position.global_position
	clone.global_rotation = player_exit_position.global_rotation
	clone._set_player_anim(clone.AnimStates.EXIT)
	await _set_door_anim(AnimStates.EXIT)
	rig.visible = true
	clone.queue_free()
	request_planet_change.emit(destination_planet_ID)
	print("requesting planet change")
	_set_door_anim(AnimStates.STASIS)
	

signal request_planet_change(planet_ID : int)
signal request_music_change

func _process(_delta: float) -> void:
	if current_anim != AnimStates.EXIT:
		var sphere_center = Vector3(0.0,0.0,0.0)
		var toDoor = global_position - sphere_center
		var surface_normal = toDoor.normalized()
		door_skele.look_at(player.global_position, surface_normal)

func _on_tree_entered() -> void:
	add_to_group("Active_Door")
	print ("added to actives")

func _on_tree_exited() -> void:
	remove_from_group("Active_Door")
	print ("removed from actives")
