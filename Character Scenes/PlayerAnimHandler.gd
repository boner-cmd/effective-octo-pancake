extends Node3D

@export var walk_cycle_time: Timer 
@export var honk_delay: Timer
@onready var item_get_sprite: Sprite3D = $ItemGetLocator/Item_Get_Sprite
@onready var item_give_sprite: Sprite3D = $ItemGiveLocator/Item_Give_Sprite

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
	if anim != current_anim:
		current_anim = anim
		item_get_sprite.visible = false
		item_give_sprite.visible = false
		item_get_sprite.timer.stop()
		item_get_sprite.timer.wait_time = 0.1
		item_give_sprite.timer.stop()
		item_give_sprite.timer.wait_time = 0.1
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
				item_get_sprite.update_icon()
				AudioManager.sfx_play(AudioManager.sfx_get_item)
				item_get_sprite.visible = true
				item_get_sprite.timer.start()
				anim_tree.set("parameters/Walk/blend_amount", 0.0)
				anim_tree.set("parameters/Exit/blend_amount", 0.0)
				anim_tree.set("parameters/Victory/blend_amount", 0.0)
				
				anim_tree.set("parameters/Talk/blend_amount", 1.0)
				anim_tree.set("parameters/Get/blend_amount", 1.0)
				anim_tree.set("parameters/Give/blend_amount", 0.0)
				
			AnimStates.GIVE:
				item_give_sprite.update_icon()
				AudioManager.sfx_play(AudioManager.sfx_give_item)
				item_give_sprite.visible = true
				item_give_sprite.timer.start()
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
