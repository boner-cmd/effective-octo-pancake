extends Sprite3D
@export var scale_goal : float = 0.1
@onready var timer: Timer = $Timer
var current_npc

const item_resources_get : Dictionary[QuestManager.CharacterName, Resource] = {
	QuestManager.CharacterName.KING_1 : preload("res://item sprites/kings_key.png"),
	QuestManager.CharacterName.HORSE : preload("res://item sprites/gibberish.png"),
	QuestManager.CharacterName.ASTRO : preload("res://item sprites/space_blanket.png"),
	QuestManager.CharacterName.SNOWMAN : preload("res://item sprites/carrot.png"),
	QuestManager.CharacterName.GREASE : preload("res://item sprites/oil_drop.png"),
	QuestManager.CharacterName.DEER : preload("res://item sprites/idea.png"),
	QuestManager.CharacterName.O : preload("res://item sprites/two_small_Os.png"),
	QuestManager.CharacterName.ORGANS : preload("res://item sprites/organs.png"),
	QuestManager.CharacterName.MASS : preload("res://item sprites/burrito.png"),
	QuestManager.CharacterName.LAMP : preload("res://item sprites/jungian_shadow.png"),
	QuestManager.CharacterName.MICHAEL : preload("res://item sprites/slime_mold_game.png"),
	QuestManager.CharacterName.ROBOT : preload("res://item sprites/oxygen_tank_item.png"),
	QuestManager.CharacterName.GIBBERISH : preload("res://item sprites/diagonal line.png"),
	QuestManager.CharacterName.IDEA : preload("res://item sprites/light_bulb.png"),
	QuestManager.CharacterName.BODHI : preload("res://item sprites/dharmachaka.png"),
	QuestManager.CharacterName.SLIME : preload("res://item sprites/slime_mold_game.png")
}

func update_icon():
	current_npc = DialogueManager.current_npc
	texture = item_resources_get[current_npc]

func item_tween():
	timer.wait_time = 1.0
	var tween_item_get = get_tree().create_tween()
	if scale_goal == 0.01:
		scale_goal = 1.0
		tween_item_get.tween_property(self, "scale:x",  scale_goal, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	else:
		scale_goal = 0.01
		tween_item_get.tween_property(self, "scale:x",  scale_goal, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween_item_get.play()
	await tween_item_get.finished
	if tween_item_get and tween_item_get.is_valid():
		tween_item_get.kill()
