extends Node3D
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
			anim_tree.set("parameters/Walk/blend_amount", 0.0)
			anim_tree.set("parameters/Exit/blend_amount", 0.0)
			anim_tree.set("parameters/Victory/blend_amount", 0.0)
			
			anim_tree.set("parameters/Talk/blend_amount", 1.0)
			anim_tree.set("parameters/Get/blend_amount", 1.0)
			anim_tree.set("parameters/Give/blend_amount", 0.0)
		AnimStates.GIVE:
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
