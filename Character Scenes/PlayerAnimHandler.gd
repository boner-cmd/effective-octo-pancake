extends Node3D

@export var walk_cycle_time: Timer 
@export var honk_delay: Timer

func honk_sound_player():
	var honk_time = honk_delay.duplicate()
	get_tree().root.add_child(honk_time)
	honk_time.start()
	await honk_time.timeout
	AudioManager.sfx_play(AudioManager.sfx_honk)
	honk_time.queue_free()

func _on_walk_cycle_time_timeout() -> void:
	if current_anim == AnimStates.WALK:
		AudioManager.sfx_play(AudioManager.sfx_walk)

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
			AudioManager.sfx_play(AudioManager.sfx_jump)
			honk_sound_player()
			anim_tree.set("parameters/Jump/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
			anim_tree.set("parameters/Walk/blend_amount", 0.0)
			anim_tree.set("parameters/Exit/blend_amount", 0.0)
			anim_tree.set("parameters/Victory/blend_amount", 0.0)
			anim_tree.set("parameters/Talk/blend_amount", 0.0)
			anim_tree.set("parameters/Get/blend_amount", 0.0)
			anim_tree.set("parameters/Give/blend_amount", 0.0)
			
			await anim_tree.animation_finished
			if !DialogueManager.is_dialogue_active:
				_set_player_anim(AnimStates.IDLE)
			else:
				anim_tree.set("parameters/Talk/blend_amount", 1.0)
				
		AnimStates.GET:
			AudioManager.sfx_play(AudioManager.sfx_get_item)
			anim_tree.set("parameters/Walk/blend_amount", 0.0)
			anim_tree.set("parameters/Exit/blend_amount", 0.0)
			anim_tree.set("parameters/Victory/blend_amount", 0.0)
			
			anim_tree.set("parameters/Talk/blend_amount", 1.0)
			anim_tree.set("parameters/Get/blend_amount", 1.0)
			anim_tree.set("parameters/Give/blend_amount", 0.0)
			
		AnimStates.GIVE:
			AudioManager.sfx_play(AudioManager.sfx_give_item)
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
			AudioManager.sfx_play(AudioManager.sfx_explode, 0.0)
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
