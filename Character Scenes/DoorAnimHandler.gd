extends Node3D

enum AnimStates {IDLE, STASIS, SPAWN, DESPAWN, EXIT}

var player : CharacterBody3D

@onready var temp_camera_location : Node3D = $DoorAnims/DoorCameraPosition
var door_camera_position : Vector3
var door_camera_rotation : Vector3
var temp_rotation : Vector3
var towards_rotation : float

var door_locked : bool = false
var current_anim := AnimStates.STASIS
var door_mats : Dictionary[int, Material] = {
	0 : preload("res://planets/materials/01_kings_planet_mat.tres"),
	1 : preload("res://planets/materials/02_horse_planet.tres"),
	2 : preload("res://planets/materials/03_astronaut_planet.tres"),
	3 : preload("res://planets/materials/04_snowman_door.tres"),
	4 : preload("res://planets/materials/17_Sisyphus_planet.tres"),
	5 : preload("res://planets/materials/07_grease_planet.tres"),
	6 : preload("res://planets/materials/10_Deer_planet.tres"),
	7 : preload("res://planets/materials/05_gatekeeper_planet.tres"),
	8 : preload("res://planets/materials/09_O_planet.tres"),
	9 : preload("res://planets/materials/15_Organs_planet.tres"),
	10 : preload("res://planets/materials/18_Mass_planet.tres"),
	11 : preload("res://planets/materials/12_Lamp_planet.tres"),
	12 : preload("res://planets/materials/14_Norgans_door.tres"),
	13 : preload("res://planets/materials/19_Michaelwave_planet.tres"),
	14 : preload("res://planets/materials/06_rusty_planet.tres"),
	15 : preload("res://planets/materials/13_Individual_planet.tres"),
	16 : preload("res://planets/materials/08_gibberish_planet.tres"),
	17 : preload("res://planets/materials/11_Idea_planet.tres"),
	18 : preload("res://planets/materials/16_Bodhi_planet.tres"),
	19 : preload("res://planets/materials/20_Slime_planet.tres"),
	20 : preload("res://planets/materials/01_kings_planet_mat.tres"),
}

@export var destination_planet_ID : int

@onready var main_ : Node3D
@onready var door_skele: Node3D = $DoorAnims
@onready var door_mesh: MeshInstance3D = $DoorAnims/Skeleton3D/Door
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var player_exit_position: Node3D = $DoorAnims/PlayerAnimationPosition

signal exit_anim_finished()
signal exit_anim_started()
signal request_planet_change(planet_ID : int)

func change_king_door():
	if destination_planet_ID == QuestManager.CharacterName.KING_1:
		destination_planet_ID = QuestManager.CharacterName.KING_2 

func lock_check():
	var sisyphus_lock = DialogueManager.sisyphus_lock
	var gate_lock = DialogueManager.gate_lock
	var king2_lock = DialogueManager.king2_lock

	if destination_planet_ID == QuestManager.CharacterName.ROBOT:
		door_locked = gate_lock
	if destination_planet_ID == QuestManager.CharacterName.INDIVIDUAL:
		door_locked = gate_lock
	if destination_planet_ID == QuestManager.CharacterName.SLIME:
		door_locked = sisyphus_lock
	if destination_planet_ID == QuestManager.CharacterName.KING_2:
		door_locked = king2_lock

func _set_door_anim(anim : AnimStates):
	current_anim = anim
	lock_check()
	if !door_locked:
		match current_anim:
			AnimStates.STASIS:
				anim_tree.set("parameters/Door_Active/blend_amount", 0.0)
				anim_tree.set("parameters/DoorExit/blend_amount", 0.0)
				
			AnimStates.SPAWN:
				AudioManager.sfx_play(AudioManager.sfx_spawn)
				anim_tree.set("parameters/Reset_DoorSpawn/seek_request", 0.0)
				anim_tree.set("parameters/DoorSpawnTimescale/scale", 2.0)
				anim_tree.set("parameters/Door_Active/blend_amount", 1.0)
				await anim_tree.animation_finished
				_set_door_anim(AnimStates.IDLE)
				
			AnimStates.IDLE:
				anim_tree.set("parameters/DoorIdle_Reset/seek_request", 0.0)
				anim_tree.set("parameters/Door_Idle/blend_amount", 0.0)

			AnimStates.DESPAWN:
				AudioManager.sfx_play(AudioManager.sfx_despawn)
				anim_tree.set("parameters/Door_Idle/blend_amount", 1.0)
				anim_tree.set("parameters/Reset_DoorSpawn/seek_request", 1.0)
				anim_tree.set("parameters/DoorSpawnTimescale/scale", -2.0)
				
			AnimStates.EXIT:
				AudioManager.sfx_play(AudioManager.sfx_exit, 0.0)
				exit_anim_started.emit()
				anim_tree.set("parameters/Reset_DoorExit/seek_request", 0.0)
				anim_tree.set("parameters/DoorExit/blend_amount", 1.0)
				await anim_tree.animation_finished
				exit_anim_finished.emit()
				_set_door_anim(AnimStates.STASIS)
	else:
		#AnimStates.STASIS:
		anim_tree.set("parameters/Door_Active/blend_amount", 0.0)
		anim_tree.set("parameters/DoorExit/blend_amount", 0.0)
		pass

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	_set_door_anim(AnimStates.STASIS)
	main_ = get_tree().get_root().get_node("MainScene")
	door_mesh.set_surface_override_material(0, door_mats[destination_planet_ID])
	DialogueManager.change_king.connect(change_king_door)
	

func spawn():
	_set_door_anim(AnimStates.SPAWN)

func despawn():
	_set_door_anim(AnimStates.DESPAWN)

func _on_door_spawn_radius_area_entered(_area: Area3D) -> void:
	_set_door_anim(AnimStates.SPAWN)

func _on_door_spawn_radius_area_exited(_area: Area3D) -> void:
	_set_door_anim(AnimStates.DESPAWN)

func stasis():
	_set_door_anim(AnimStates.STASIS)

func interact():
	lock_check()
	if !door_locked:
		if player.exit_check == false:
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
			_set_door_anim(AnimStates.STASIS)
	else:
		AudioManager.sfx_play(AudioManager.sfx_honk, -.5)

func _process(_delta: float) -> void:
	if current_anim != AnimStates.EXIT:
		self.look_at(player.global_position)
		rotation.x = 0
		rotation.z = 0
