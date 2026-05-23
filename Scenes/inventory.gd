extends MarginContainer

var inventory_slots = {
	Slot1 = false,
	Slot2 = false,
	Slot3 = false,
}

var slot_state : int = 0b000
@onready var item_slot1  : TextureRect = $VBoxContainer/ItemSlot1
@onready var item_slot2  : TextureRect = $VBoxContainer/ItemSlot2
@onready var item_slot3  : TextureRect = $VBoxContainer/ItemSlot3 
@onready var label_slot1 : Label = $VBoxContainer/ItemSlot1/ItemSlot1Label
@onready var label_slot2 : Label = $VBoxContainer/ItemSlot2/ItemSlot2Label
@onready var label_slot3 : Label = $VBoxContainer/ItemSlot3/ItemSlot3Label

const item_resources : Dictionary[String, Resource] = {
	King 		= preload("res://Placeholder Assets (UI)/icon.svg"), # sample, replace with item icon
	Horse 		= preload("res://Placeholder Assets (UI)/icon.svg"), # sample, replace with item icon
	Astronaut 	= preload("res://Placeholder Assets (UI)/icon.svg"), # sample, replace with item icon
	Snowman 	= preload("res://Placeholder Assets (UI)/icon.svg"), # sample, replace with item icon
	Grease 		= preload("res://Placeholder Assets (UI)/icon.svg"), # sample, replace with item icon
	Deer 		= preload("res://Placeholder Assets (UI)/icon.svg"), # sample, replace with item icon
	O 			= preload("res://Placeholder Assets (UI)/icon.svg"), # sample, replace with item icon
	Organs 		= preload("res://Placeholder Assets (UI)/icon.svg"), # sample, replace with item icon
	Mass 		= preload("res://Placeholder Assets (UI)/icon.svg"), # sample, replace with item icon
	Lamp 		= preload("res://Placeholder Assets (UI)/icon.svg"), # sample, replace with item icon
	Michaelwave = preload("res://Placeholder Assets (UI)/icon.svg"), # sample, replace with item icon
	Robot 		= preload("res://Placeholder Assets (UI)/icon.svg"), # sample, replace with item icon
	Gibberish 	= preload("res://Placeholder Assets (UI)/icon.svg"), # sample, replace with item icon
	Idea 		= preload("res://Placeholder Assets (UI)/icon.svg"), # sample, replace with item icon
	Bodhi 		= preload("res://Placeholder Assets (UI)/icon.svg"), # sample, replace with item icon
}

const item_texts : Dictionary[String, String] = {
	King 		= "Key",
	Horse 		= "sagfuiasgfuiasgfasuig",
	Astronaut 	= "Space Blanket",
	Snowman 	= "Carrot",
	Grease 		= "Grease Puddle",
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

func add_item(npc_name : String) -> void:
	update_slots() # move items out of the third slot, just in case
	assert(!inventory_slots.Slot3, "Tried to add a fourth item, check inventory state")
	assert(item_texts.has(npc_name), "Tried to add an unknown item, check npc_name")
	inventory_slots.Slot3 = npc_name
	update_slots()
	
func remove_item(npc_name : String) -> void:
	var found_key : String = inventory_slots.find_key(npc_name)
	assert(found_key, "Tried to remove a non-existent item from inventory, check npc_name")
	inventory_slots[found_key] = false
	update_slots()

func update_slots() -> void:
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

	if slot_state & 0b100:
		item_slot1.texture = item_resources[inventory_slots.Slot1]
		label_slot1.text = item_texts[inventory_slots.Slot1]
	if slot_state & 0b010:
		item_slot2.texture = item_resources[inventory_slots.Slot2]
		label_slot2.text = item_texts[inventory_slots.Slot2]
	if slot_state & 0b001:
		item_slot3.texture = item_resources[inventory_slots.Slot3]
		label_slot3.text = item_texts[inventory_slots.Slot3]

func _ready() -> void:
	visible = true
