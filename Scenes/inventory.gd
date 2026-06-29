extends Control

const item_slot_empty : ShaderMaterial = preload("res://UI assets/UIShaders/SMALL_UI_MATERIAL_3.tres")
const item_slot_full : ShaderMaterial = preload("res://UI assets/UIShaders/SMALL_UI_MATERIAL_1.tres")

# each item is the one GIVEN by that NPC
const item_resources : Dictionary[QuestManager.CharacterName, Resource] = {
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
const item_texts : Dictionary[QuestManager.CharacterName, String] = {
	QuestManager.CharacterName.KING_1 : "Key",
	QuestManager.CharacterName.HORSE : "sagfuiasgfuiasgfasuig",
	QuestManager.CharacterName.ASTRO : "Space Blanket",
	QuestManager.CharacterName.SNOWMAN : "Carrot",
	QuestManager.CharacterName.GREASE : "Oil",
	QuestManager.CharacterName.DEER : "Idea",
	QuestManager.CharacterName.O : "Two small 'o's",
	QuestManager.CharacterName.ORGANS : "Organs",
	QuestManager.CharacterName.MASS : "Burrito",
	QuestManager.CharacterName.LAMP : "Jungian Shadow",
	QuestManager.CharacterName.MICHAEL : "Slime Mould Game",
	QuestManager.CharacterName.ROBOT : "Oxygen Tank",
	QuestManager.CharacterName.GIBBERISH : "Diagonal Line",
	QuestManager.CharacterName.IDEA : "Lightbulb",
	QuestManager.CharacterName.BODHI : "Dharmachakra",
	QuestManager.CharacterName.SLIME : "Slime Mould Game",
	}
const origin_by_desiring_npc :  Dictionary[QuestManager.CharacterName, QuestManager.CharacterName] = { # given y = x, x has what y needs
	QuestManager.CharacterName.GATE : QuestManager.CharacterName.KING_1,
	QuestManager.CharacterName.HORSE : QuestManager.CharacterName.SNOWMAN,
	QuestManager.CharacterName.ASTRO : QuestManager.CharacterName.ROBOT,
	QuestManager.CharacterName.ROBOT : QuestManager.CharacterName.GREASE,
	QuestManager.CharacterName.DEER : QuestManager.CharacterName.O,
	QuestManager.CharacterName.IDEA : QuestManager.CharacterName.DEER,
	QuestManager.CharacterName.NORGANS : QuestManager.CharacterName.ORGANS,
	QuestManager.CharacterName.LAMP : QuestManager.CharacterName.IDEA,
	QuestManager.CharacterName.INDIVIDUAL : QuestManager.CharacterName.LAMP,
	QuestManager.CharacterName.MICHAEL : QuestManager.CharacterName.MASS,
	QuestManager.CharacterName.GIBBERISH : QuestManager.CharacterName.HORSE,
	QuestManager.CharacterName.SISYPHUS : QuestManager.CharacterName.BODHI,
	QuestManager.CharacterName.SLIME : QuestManager.CharacterName.MICHAEL,
	QuestManager.CharacterName.SNOWMAN : QuestManager.CharacterName.ASTRO,
	QuestManager.CharacterName.KING_2 : QuestManager.CharacterName.SLIME,
	QuestManager.CharacterName.O : QuestManager.CharacterName.GIBBERISH,
	}

var inventory_slots : Dictionary[StringName, int] = {
	&"Slot1" : 0,
	&"Slot2" : 0,
	&"Slot3" : 0,
	}
var slot_state : int = 0b000

@onready var item_get_sprite: Sprite3D = $"/root/MainScene/PlayerCharacter/ClownRigFBX/ItemGetLocator/Item_Get_Sprite"
@onready var item_give_sprite: Sprite3D = $"/root/MainScene/PlayerCharacter/ClownRigFBX/ItemGiveLocator/Item_Give_Sprite"
@onready var item_slot1  : TextureRect = $ItemSlot1
@onready var item_slot2  : TextureRect = $ItemSlot2
@onready var item_slot3  : TextureRect = $ItemSlot3
@onready var label_slot1 : Label = $ItemSlot1/ItemSlot1Label
@onready var label_slot2 : Label = $ItemSlot2/ItemSlot2Label
@onready var label_slot3 : Label = $ItemSlot3/ItemSlot3Label
@onready var item_slot1_bg  : Sprite2D = $ItemSlot1Contents
@onready var item_slot2_bg  : Sprite2D = $ItemSlot2Contents
@onready var item_slot3_bg : Sprite2D = $ItemSlot3Contents

func add_item(npc_name : QuestManager.CharacterName) -> void:
	assert(not inventory_slots.Slot3, "Tried to add a fourth item, check inventory state")
	assert(item_texts.has(npc_name), "Tried to add an unknown item, check npc_name")
	inventory_slots.Slot3 = npc_name
	item_get_sprite.texture = item_resources[npc_name]
	slot_state |= 0b001
	update_slots()


func remove_item(npc_name : QuestManager.CharacterName) -> void:
	var found_key : String = inventory_slots.find_key(npc_name)
	item_give_sprite.texture = item_resources[npc_name]
	assert(found_key, "Tried to remove a non-existent item from inventory, check npc_name")
	inventory_slots[found_key] = 0
	match found_key:
		&"Slot1":
			# remove item in slot 1
			slot_state &= 0b011
		&"Slot2":
			# remove item in slot 2
			slot_state &= 0b101
		&"Slot3":
			# remove item in slot 3
			slot_state &= 0b110
	update_slots()


func update_slots() -> void:
	item_slot1.visible = false
	item_slot2.visible = false
	item_slot3.visible = false
	item_slot1_bg.material = item_slot_empty
	item_slot2_bg.material = item_slot_empty
	item_slot3_bg.material = item_slot_empty
	
	match (slot_state):
		0b001:
			inventory_slots.Slot1 = inventory_slots.Slot3
			inventory_slots.Slot3 = 0
			slot_state = 0b100
		0b010:
			inventory_slots.Slot1 = inventory_slots.Slot2
			inventory_slots.Slot2 = 0
			slot_state = 0b100
		0b011:
			inventory_slots.Slot1 = inventory_slots.Slot2
			inventory_slots.Slot2 = inventory_slots.Slot3
			inventory_slots.Slot3 = 0
			slot_state = 0b110
		0b101:
			inventory_slots.Slot2 = inventory_slots.Slot3
			inventory_slots.Slot3 = 0
			slot_state = 0b110
		_: 
			pass

	if slot_state & 0b100:
		item_slot1.texture = item_resources[inventory_slots.Slot1]
		label_slot1.text = item_texts[inventory_slots.Slot1]
		item_slot1.visible = true
		item_slot1_bg.material = item_slot_full
	if slot_state & 0b010:
		item_slot2.texture = item_resources[inventory_slots.Slot2]
		label_slot2.text = item_texts[inventory_slots.Slot2]
		item_slot2.visible = true
		item_slot2_bg.material = item_slot_full
	if slot_state & 0b001:
		item_slot3.texture = item_resources[inventory_slots.Slot3]
		label_slot3.text = item_texts[inventory_slots.Slot3]
		item_slot3.visible = true
		item_slot3_bg.material = item_slot_full


func _ready() -> void:
	update_slots()
	DialogueManager.request_item_add.connect(_on_item_add_requested)
	DialogueManager.request_item_remove.connect(_on_item_remove_requested)


func _on_item_add_requested(giver_name : QuestManager.CharacterName) -> void:
	add_item(giver_name)
	SaveManager.save_game()


func _on_item_remove_requested(receiver_name : QuestManager.CharacterName) -> void:
	remove_item(origin_by_desiring_npc[receiver_name])
	SaveManager.save_game()
