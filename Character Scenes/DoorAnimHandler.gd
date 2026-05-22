extends Node3D
@onready var anim_tree: AnimationTree = $AnimationTree

enum AnimStates {IDLE, STASIS, SPAWN, DESPAWN, EXIT}

var current_anim := AnimStates.STASIS

func _set_door_anim():
	match current_anim:
		AnimStates.STASIS:
			anim_tree.set("parameters/Door_Active/blend_amount", 0.0)
			
		AnimStates.SPAWN:
			anim_tree.set("parameters/Reset_DoorSpawn/seek_request", 0.0)
			anim_tree.set("parameters/DoorSpawnTimescale/scale", 2.0)
			anim_tree.set("parameters/Door_Active/blend_amount", 1.0)
			
		AnimStates.IDLE:
			anim_tree.set("parameters/DoorIdle_Reset/seek_request", 0.0)
			anim_tree.set("parameters/Door_Idle/blend_amount", 0.0)

		AnimStates.DESPAWN:
			anim_tree.set("parameters/Reset_DoorSpawn/seek_request", 1.0)
			anim_tree.set("parameters/DoorSpawnTimescale/scale", -2.0)
			await anim_tree.animation_finished
			exit_anim_finished.emit()
			current_anim = AnimStates.STASIS
			_set_door_anim()
			
		AnimStates.EXIT:
			anim_tree.set("parameters/Reset_DoorExit/seek_request", 0.0)
			anim_tree.set("parameters/DoorExit/blend_amount", 1.0)
			await anim_tree.animation_finished
			current_anim = AnimStates.STASIS
			_set_door_anim()

signal exit_anim_finished
