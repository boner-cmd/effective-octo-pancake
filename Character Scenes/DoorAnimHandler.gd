extends Node3D

const door_mats : Dictionary[int, Material] = {
	0 : preload("res://planets/materials/01_kings_door.tres"),
	1 : preload("res://planets/materials/02_horse_door.tres"),
	2 : preload("res://planets/materials/03_astronaut_door.tres"),
	3 : preload("res://planets/materials/04_snowman_door.tres"),
	4 : preload("res://planets/materials/17_Sisyphus_door.tres"),
	5 : preload("res://planets/materials/07_grease_door.tres"),
	6 : preload("res://planets/materials/10_Deer_door.tres"),
	7 : preload("res://planets/materials/05_gatekeeper_door.tres"),
	8 : preload("res://planets/materials/09_O_door.tres"),
	9 : preload("res://planets/materials/15_Organs_door.tres"),
	10 : preload("res://planets/materials/18_Mass_door.tres"),
	11 : preload("res://planets/materials/12_Lamp_door.tres"),
	12 : preload("res://planets/materials/14_Norgans_door.tres"),
	13 : preload("res://planets/materials/19_Michaelwave_door.tres"),
	14 : preload("res://planets/materials/06_robot_door.tres"),
	15 : preload("res://planets/materials/13_Individual_door.tres"),
	16 : preload("res://planets/materials/08_gibberish_door.tres"),
	17 : preload("res://planets/materials/11_Idea_door.tres"),
	18 : preload("res://planets/materials/16_Bodhi_door.tres"),
	19 : preload("res://planets/materials/20_Slime_door.tres"),
	20 : preload("res://planets/materials/01_kings_door.tres"),
	21 : null
}

enum AnimStates {IDLE, STASIS, SPAWN, DESPAWN, EXIT}

var player : CharacterBody3D
var player_rig : Node3D
var player_vfx : Node3D
var temp_rotation : Vector3
var towards_rotation : float

var door_locked : bool = false
var current_anim := AnimStates.STASIS
var previous_anim := AnimStates.STASIS

var clone
var clone_vfx : Node3D
var temp_confetti_name : StringName = &"VictoryConfettiParticlesFalling"
var temp_still_name : StringName = &"VictoryConfettiStill"
var temp_smoke_name : StringName = &"VictorySmoke"
var temp_attactor_sphere_name : StringName = &"GPUParticlesAttractorSphere3D"
var temp_collision_name : StringName = &"GPUParticlesCollisionSphere3D"
var temp_poof_name : StringName = &"WalkPoofParticles"
var temp_box_name : StringName = &"GPUParticlesCollisionBox3D"

@export var destination_planet_ID : int

@onready var main_ : Node3D
@onready var door_skele: Node3D = $DoorAnims
@onready var door_mesh: MeshInstance3D = $DoorAnims/Skeleton3D/Door
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var player_exit_position: Node3D = $DoorAnims/PlayerAnimationPosition
@onready var spawn_poof_particles: GPUParticles3D = $DoorVFX/SpawnPoofParticles
@onready var vfx_parent : Node3D = $DoorVFX
@onready var door_camera: Camera3D = $DoorAnims/Camera3D
@onready var stasis_particles: GPUParticles3D = $DoorVFX/StasisParticles


signal exit_anim_finished()
signal exit_anim_started()
signal request_planet_change(planet_ID : int)

func change_king_door():
	if destination_planet_ID == QuestManager.CharacterName.KING_1:
		destination_planet_ID = QuestManager.CharacterName.KING_2 


func lock_check():
	var horse_lock = DialogueManager.horse_lock
	var sisyphus_lock = DialogueManager.sisyphus_lock
	var gate_lock = DialogueManager.gate_lock
	var king2_lock = DialogueManager.king2_lock
	
	if destination_planet_ID == QuestManager.CharacterName.HORSE:
		door_locked = horse_lock
	if destination_planet_ID == QuestManager.CharacterName.ROBOT:
		door_locked = gate_lock
	if destination_planet_ID == QuestManager.CharacterName.INDIVIDUAL:
		door_locked = gate_lock
	if destination_planet_ID == QuestManager.CharacterName.SLIME:
		door_locked = sisyphus_lock
	if destination_planet_ID == QuestManager.CharacterName.KING_2:
		door_locked = king2_lock


func _set_door_anim(anim : AnimStates):
	previous_anim = current_anim
	current_anim = anim
	stasis_particles.emitting = false
	stasis_particles.lifetime = 0.01
	stasis_particles.amount = 1
	lock_check()
	if not door_locked:
		match current_anim:
			AnimStates.STASIS:
				stasis_particles.lifetime = 3.0
				stasis_particles.amount = 6
				stasis_particles.emitting = true
				anim_tree.set("parameters/Door_Active/blend_amount", 0.0)
				anim_tree.set("parameters/DoorExit/blend_amount", 0.0)
				anim_tree.set("parameters/Door_Idle/blend_amount", 1.0)
				
			AnimStates.SPAWN:
				emit_poof_particles()
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
				if previous_anim == AnimStates.IDLE:
					emit_poof_particles()
				delay_sleeping_particles()
				AudioManager.sfx_play(AudioManager.sfx_despawn)
				anim_tree.set("parameters/Door_Idle/blend_amount", 1.0)
				anim_tree.set("parameters/Reset_DoorSpawn/seek_request", 1.0)
				anim_tree.set("parameters/DoorSpawnTimescale/scale", -2.0)
				
			AnimStates.EXIT:
				exit_anim_particles()
				AudioManager.sfx_play(AudioManager.sfx_exit, 0.0)
				exit_anim_started.emit()
				anim_tree.set("parameters/Reset_DoorExit/seek_request", 0.0)
				anim_tree.set("parameters/DoorExit/blend_amount", 1.0)
				await anim_tree.animation_finished
				exit_anim_finished.emit()
				_set_door_anim(AnimStates.STASIS)
	else:
		pass


func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	stasis()
	main_ = get_tree().get_root().get_node("MainScene")
	door_mesh.set_surface_override_material(0, door_mats[destination_planet_ID])
	DialogueManager.change_king.connect(change_king_door)
	tree_entered.connect(stasis)


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
	if not door_locked:
		if player.exit_check == false:
			player.exit_check = true
			door_camera.make_current()
			for children in player.get_children():
				if children.name == &"ClownRigFBX":
					player_rig = children
			clone = player_rig.duplicate()
			for detector in clone.get_children():
				if detector.name == &"InteractionDetector":
					detector.queue_free()
			get_tree().root.add_child(clone)
			transfer_vfx_to_clone()
			player_rig.visible = false
			player_rig._set_player_anim(player_rig.AnimStates.IDLE)
			clone.global_position = player_exit_position.global_position
			clone.global_rotation = player_exit_position.global_rotation
			clone._set_player_anim(clone.AnimStates.EXIT)
			await _set_door_anim(AnimStates.EXIT)
			player_rig.visible = true
			transfer_vfx_to_player()
			clone.queue_free()
			request_planet_change.emit(destination_planet_ID)
			player._camera.make_current()
			_set_door_anim(AnimStates.STASIS)
	else:
		AudioManager.sfx_play(AudioManager.sfx_sadhonk)


func _process(_delta: float) -> void:
	if current_anim != AnimStates.EXIT:
		self.look_at(player.global_position)
		rotation.x = 0
		rotation.z = 0


func emit_poof_particles() -> void:
	var particle_copy = spawn_poof_particles.duplicate()
	add_child.call_deferred(particle_copy)
	particle_copy.restart()
	await particle_copy.finished
	particle_copy.queue_free()


func exit_anim_particles() -> void:
	var clone_vfx_door = vfx_parent.duplicate()
	add_child.call_deferred(clone_vfx_door)
	for animplayer in clone_vfx_door.get_children():
		if animplayer is AnimationPlayer:
			animplayer.play("VFX_Door_Sequence")
			await animplayer.animation_finished
			clone_vfx_door.queue_free()


func delay_sleeping_particles() -> void:
	await get_tree().create_timer(.5).timeout
	stasis_particles.lifetime = 3.0
	stasis_particles.amount = 1
	stasis_particles.emitting = true
	stasis_particles.amount = 6


func transfer_vfx_to_clone() -> void:
	for node in clone.get_children():
		if node.name == &"PlayerVFX":
			node.name = &"CloneVFX"
	for node in player_rig.get_children():
		if node.name == &"PlayerVFX":
			player_vfx = node
	player_vfx.reparent(clone)
	clone_vfx = player_vfx
	player_vfx.position = Vector3(0.0,0.0,0.0)
	player_vfx.rotation = Vector3(0.0,0.0,0.0)


func transfer_vfx_to_player() -> void:
	player_vfx.reparent(player_rig)
	player_vfx.position = Vector3(0.0,0.0,0.0)
	player_vfx.rotation = Vector3(0.0,0.0,0.0)
