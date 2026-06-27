extends Node3D

enum AnimStates {IDLE, WALK, JUMP, GET, GIVE, TALK, VICTORY, EXIT}

@onready var anim_tree: AnimationTree = $AnimationTree
@onready var walk_cycle_time: Timer = $walk_cycle_time
@export var honk_delay: Timer
@onready var player_vfx: Node3D = $PlayerVFX

var current_anim := AnimStates.IDLE
var item_get_sprite: Sprite3D
var item_give_sprite: Sprite3D
var item_give_bg : AnimatedSprite3D
var item_get_bg : AnimatedSprite3D


func _ready() -> void:
	if not get_parent().name == "Node3D" and not get_parent().name == "Victory Scene":
		item_get_sprite = $ItemGetLocator/Item_Get_Sprite
		item_get_bg = $ItemGetLocator/Item_Get_Sprite_BG
		item_give_sprite = $ItemGiveLocator/Item_Give_Sprite
		item_give_bg = $ItemGiveLocator/Item_Give_Sprite_BG


func honk_sound_player():
	var honk_time = honk_delay.duplicate()
	get_tree().root.add_child(honk_time)
	honk_time.start()
	await honk_time.timeout
	AudioManager.sfx_play(AudioManager.sfx_honk)
	honk_time.queue_free()


func _on_walk_cycle_time_timeout() -> void:
	if current_anim == AnimStates.WALK and not DialogueManager.is_dialogue_active:
		AudioManager.sfx_play(AudioManager.sfx_walk)


func _get_current_anim() -> AnimStates:
	return current_anim

func _set_player_anim(anim : AnimStates):
	if anim != current_anim:
		current_anim = anim
		if item_get_sprite:
			item_get_bg.visible = false
			item_get_sprite.visible = false
			item_get_sprite.timer.stop()
			item_get_sprite.timer.wait_time = 0.1
		if item_give_sprite:
			item_give_bg.visible = false
			item_give_sprite.visible = false
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
				honk_sound_player()
				HonkCounter.add_honk()
				anim_tree.set("parameters/Jump/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
				anim_tree.set("parameters/Walk/blend_amount", 0.0)
				anim_tree.set("parameters/Exit/blend_amount", 0.0)
				anim_tree.set("parameters/Victory/blend_amount", 0.0)
				anim_tree.set("parameters/Talk/blend_amount", 0.0)
				anim_tree.set("parameters/Get/blend_amount", 0.0)
				anim_tree.set("parameters/Give/blend_amount", 0.0)
				
				await anim_tree.animation_finished
				if not DialogueManager.is_dialogue_active:
					_set_player_anim(AnimStates.IDLE)
				else:
					anim_tree.set("parameters/Talk/blend_amount", 1.0)
					
			AnimStates.GET:
				item_get_sprite.scale.x = .5
				item_get_sprite.scale_goal = .01
				item_get_sprite.update_icon()
				AudioManager.sfx_play(AudioManager.sfx_get_item)
				item_get_sprite.visible = true
				item_get_bg.visible = true
				item_get_sprite.timer.start()
				anim_tree.set("parameters/Walk/blend_amount", 0.0)
				anim_tree.set("parameters/Exit/blend_amount", 0.0)
				anim_tree.set("parameters/Victory/blend_amount", 0.0)
				
				anim_tree.set("parameters/Talk/blend_amount", 1.0)
				anim_tree.set("parameters/Get/blend_amount", 1.0)
				anim_tree.set("parameters/Give/blend_amount", 0.0)
				
			AnimStates.GIVE:
				item_give_sprite.update_icon()
				item_give_sprite.scale.x = .5
				item_give_sprite.scale_goal = .01
				AudioManager.sfx_play(AudioManager.sfx_give_item)
				item_give_sprite.visible = true
				item_give_bg.visible = true
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
