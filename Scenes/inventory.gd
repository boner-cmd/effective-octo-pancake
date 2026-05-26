extends MarginContainer

var inventory_slots = {
	Slot1 = false,
	Slot2 = false,
	Slot3 = false,
}

var slot_state : int = 0b000
@onready var item_slot1  : TextureRect = $InventoryItemMargin/VBoxContainer/ItemSlot1
@onready var item_slot2  : TextureRect = $InventoryItemMargin/VBoxContainer/ItemSlot2
@onready var item_slot3  : TextureRect = $InventoryItemMargin/VBoxContainer/ItemSlot3
@onready var label_slot1 : Label = $InventoryItemMargin/VBoxContainer/ItemSlot1/ItemSlot1Label
@onready var label_slot2 : Label = $InventoryItemMargin/VBoxContainer/ItemSlot2/ItemSlot2Label
@onready var label_slot3 : Label = $InventoryItemMargin/VBoxContainer/ItemSlot3/ItemSlot3Label

# each item is the one GIVEN by that NPC
const item_resources : Dictionary[String, Resource] = {
	King 		= preload("res://item sprites/kings_key.png"),
	Horse 		= preload("res://item sprites/gibberish.png"),
	Astronaut 	= preload("res://item sprites/space_blanket.png"),
	Snowman 	= preload("res://item sprites/carrot.png"),
	Grease 		= preload("res://item sprites/oil_drop.png"),
	Deer 		= preload("res://item sprites/idea.png"),
	O 			= preload("res://item sprites/two_small_Os.png"),
	Organs 		= preload("res://item sprites/organs.png"),
	Mass 		= preload("res://item sprites/burrito.png"),
	Lamp 		= preload("res://item sprites/jungian_shadow.png"),
	Michaelwave = preload("res://item sprites/slime_mold_game.png"),
	Robot 		= preload("res://item sprites/oxygen_tank_item.png"),
	Gibberish 	= preload("res://item sprites/diagonal line.png"),
	Idea 		= preload("res://item sprites/light_bulb.png"),
	Bodhi 		= preload("res://item sprites/dharmachaka.png"),
}

const item_texts : Dictionary[String, String] = {
	King 		= "Key",
	Horse 		= "sagfuiasgfuiasgfasuig",
	Astronaut 	= "Space Blanket",
	Snowman 	= "Carrot",
	Grease 		= "Oil",
	Deer 		= "Idea",
	O 			= "Two small 'o's",
	Organs 		= "Organs",
	Mass 		= "Burrito",
	Lamp 		= "Jungian Shadow",
	Michaelwave = "Slime Mould Game",
	Robot 		= "Oxygen Tank",
	Gibberish 	= "Diagonal Line",
	Idea 		= "Lightbulb",
	Bodhi 		= "Dharmachakra",
}

const origin_by_desiring_npc :  Dictionary[String, String] = { # given y = x, x has what y needs
	Gate = "King",
	Horse = "Snowman",
	Astronaut = "Robot",
	Robot = "Grease",
	Deer = "O",
	Idea = "Deer",
	Norgans = "Organs",
	Lamp = "Idea",
	Individual = "Lamp",
	Michaelwave = "Mass",
	Gibberish = "Horse",
	Sisyphus = "Bodhi",
	Slime = "Michaelwave",
	King2 = "Slime",
	O = "Gibberish",
}

func add_item(npc_name : String) -> void:
	update_slots() # move items out of the third slot, just in case
	print("SLOT 3 = ", inventory_slots.Slot3)
	assert(!inventory_slots.Slot3, "Tried to add a fourth item, check inventory state")
	assert(item_texts.has(npc_name), "Tried to add an unknown item, check npc_name")
	inventory_slots.Slot3 = npc_name
	slot_state |= 0b001
	
	update_slots()
	
func remove_item(npc_name : String) -> void:
	var found_key : String = inventory_slots.find_key(npc_name) #FLAG - have wrong item for NPC, tries to assign Nil to String
	assert(found_key, "Tried to remove a non-existent item from inventory, check npc_name")
	inventory_slots[found_key] = false
	match found_key:
		"Slot1":
			slot_state &= 0b011
		"Slot2":
			slot_state &= 0b101
		"Slot3":
			slot_state &= 0b110
	update_slots()

func update_slots() -> void:
	print("SLOT STATE: ", slot_state)
	match (slot_state):
		0b001:
			inventory_slots.Slot1 = inventory_slots.Slot3
			inventory_slots.Slot3 = false
			slot_state = 0b100
		0b010:
			inventory_slots.Slot1 = inventory_slots.Slot2
			inventory_slots.Slot2 = false
			slot_state = 0b100
		0b011:
			inventory_slots.Slot1 = inventory_slots.Slot2
			inventory_slots.Slot2 = inventory_slots.Slot3
			inventory_slots.Slot3 = false
			slot_state = 0b110
		0b101:
			inventory_slots.Slot2 = inventory_slots.Slot3
			inventory_slots.Slot3 = false
			slot_state = 0b110
		_: 
			pass
			
	item_slot1.visible = false
	item_slot2.visible = false
	item_slot3.visible = false
	
	if slot_state & 0b100:
		item_slot1.texture = item_resources[inventory_slots.Slot1]
		label_slot1.text = item_texts[inventory_slots.Slot1]
		item_slot1.visible = true
	if slot_state & 0b010:
		item_slot2.texture = item_resources[inventory_slots.Slot2]
		label_slot2.text = item_texts[inventory_slots.Slot2]
		item_slot2.visible = true
	if slot_state & 0b001:
		item_slot3.texture = item_resources[inventory_slots.Slot3] #FLAG
		label_slot3.text = item_texts[inventory_slots.Slot3]
		item_slot3.visible = true

func _ready() -> void:
	visible = true
	update_slots()
	DialogueManager.request_item_add.connect(_on_item_add_requested)
	DialogueManager.request_item_remove.connect(_on_item_remove_requested)

func _on_item_add_requested(giver_name : String) -> void:
	add_item(giver_name)

func _on_item_remove_requested(receiver_name : String) -> void:
	remove_item(origin_by_desiring_npc[receiver_name])
