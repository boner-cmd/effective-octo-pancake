extends Sprite3D
@export var scale_goal : float = 0.1
@onready var timer: Timer = $Timer
var current_npc
var npcs_item

const item_resources_give :  Dictionary[QuestManager.CharacterName, Resource] = { # given y = x, x has what y needs
	QuestManager.CharacterName.GATE : preload("res://item sprites/kings_key.png"),
	QuestManager.CharacterName.HORSE : preload("res://item sprites/carrot.png"),
	QuestManager.CharacterName.ASTRO : preload("res://item sprites/oxygen_tank_item.png"),
	QuestManager.CharacterName.ROBOT : preload("res://item sprites/oil_drop.png"),
	QuestManager.CharacterName.DEER : preload("res://item sprites/two_small_Os.png"),
	QuestManager.CharacterName.IDEA : preload("res://item sprites/idea.png"),
	QuestManager.CharacterName.NORGANS : preload("res://item sprites/organs.png"),
	QuestManager.CharacterName.LAMP : preload("res://item sprites/light_bulb.png"),
	QuestManager.CharacterName.INDIVIDUAL : preload("res://item sprites/jungian_shadow.png"),
	QuestManager.CharacterName.MICHAEL : preload("res://item sprites/burrito.png"),
	QuestManager.CharacterName.GIBBERISH : preload("res://item sprites/gibberish.png"),
	QuestManager.CharacterName.SISYPHUS : preload("res://item sprites/dharmachaka.png"),
	QuestManager.CharacterName.SLIME : preload("res://item sprites/slime_mold_game.png"),
	QuestManager.CharacterName.SNOWMAN : preload("res://item sprites/space_blanket.png"),
	QuestManager.CharacterName.KING_2 : preload("res://item sprites/slime_mold_game.png"),
	QuestManager.CharacterName.O : preload("res://item sprites/diagonal line.png"),
}

func update_icon():
	current_npc = DialogueManager.current_npc
	texture = item_resources_give[current_npc]

func item_tween():
	update_icon()
	timer.wait_time = 1.0
	var tween_item_give = get_tree().create_tween()
	var tweener_give
	if scale_goal == 0.01:
		scale_goal = 1.0
		tweener_give = tween_item_give.tween_property(self, "scale:x",  scale_goal, 1.0)
		tweener_give.set_trans(Tween.TRANS_SINE)
		tweener_give.set_ease(Tween.EASE_OUT)
	else:
		scale_goal = 0.01
		tweener_give = tween_item_give.tween_property(self, "scale:x",  scale_goal, 1.0)
		tweener_give.set_trans(Tween.TRANS_SINE)
		tweener_give.set_ease(Tween.EASE_IN)
	tween_item_give.play()
	await tween_item_give.finished
	if tween_item_give and tween_item_give.is_valid():
		tween_item_give.kill()
