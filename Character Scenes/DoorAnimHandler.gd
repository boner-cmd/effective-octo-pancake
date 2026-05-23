extends Node3D
@onready var anim_tree: AnimationTree = $AnimationTree



enum AnimStates {IDLE, STASIS, SPAWN, DESPAWN, EXIT}

var current_anim := AnimStates.STASIS

# spawn		-> idle
# despawn	-> stasis
# exit		-> stasis

func _set_door_anim(anim : AnimStates):
	current_anim = anim
	match current_anim:
		AnimStates.STASIS:
			anim_tree.set("parameters/Door_Active/blend_amount", 0.0)
			
		AnimStates.SPAWN:
			anim_tree.set("parameters/Reset_DoorSpawn/seek_request", 0.0)
			anim_tree.set("parameters/DoorSpawnTimescale/scale", 2.0)
			anim_tree.set("parameters/Door_Active/blend_amount", 1.0)
			await anim_tree.animation_finished
			_set_door_anim(AnimStates.IDLE)
			
		AnimStates.IDLE:
			anim_tree.set("parameters/DoorIdle_Reset/seek_request", 0.0)
			anim_tree.set("parameters/Door_Idle/blend_amount", 0.0)

		AnimStates.DESPAWN:
			anim_tree.set("parameters/Reset_DoorSpawn/seek_request", 1.0)
			anim_tree.set("parameters/DoorSpawnTimescale/scale", -2.0)
			await anim_tree.animation_finished
			exit_anim_finished.emit()
			_set_door_anim(AnimStates.STASIS)
			
		AnimStates.EXIT:
			exit_anim_started.emit()
			anim_tree.set("parameters/Reset_DoorExit/seek_request", 0.0)
			anim_tree.set("parameters/DoorExit/blend_amount", 1.0)
			await anim_tree.animation_finished
			_set_door_anim(AnimStates.STASIS)

func _ready() -> void:
	_set_door_anim(AnimStates.STASIS)

signal exit_anim_finished
signal exit_anim_started


func _on_door_spawn_radius_area_entered(_area: Area3D) -> void:
	_set_door_anim(AnimStates.SPAWN)
	print("entered")

func _on_door_spawn_radius_area_exited(_area: Area3D) -> void:
	_set_door_anim(AnimStates.DESPAWN)
