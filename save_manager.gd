extends Node

## all invalid values on a byte basis that would contain a two-bit pair of 10 for any quest state
## in other words, the decimal digits provided correspond to all values of the pattern:
## 0b10, (2)
## 0b10XX, (8 - 11)
## 0b10XXXX, (32 - 47)
## 0b10XXXXXX. (128 - 191)
const BAD_QUEST_BYTES : PackedByteArray = [
	2, 8, 9, 10, 11, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 128, 129, 130, 
	131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 
	150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 
	169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 
	188, 189, 190, 191,
	]

var save_data : PackedByteArray
var main : Node3D
var map_visibility : Dictionary[StringName, bool]

func _ready() -> void:
	save_data.resize(4) # make sure this is actually 13 bytes wide


func save_game():
	save_data.fill(0)
	# lock logic
	# horse lock: byte 0, bit 0
	# gate lock: byte 0, bit 1
	# sisyphus lock: byte 0, bit 2
	# king_2 lock: byte 0, bit 3
	if DialogueManager.horse_lock:
		save_data[0] |= 0b1111 # if the horse door is locked, all other locks must be locked
	elif DialogueManager.gate_lock:
		save_data[0] |= 0b1110 # if gate is locked and horse is unlocked, all others must be locked
	else:
		if DialogueManager.sisyphus_lock:
			save_data[0] |= 0b100
		if DialogueManager.king2_lock:
			save_data[0] |= 0b1000
	
	# TODO pack these to remove padding between elements
	save_data.append_array(QuestManager.states)
	save_data.append(get_tree().get_first_node_in_group("Main").current_planet)
	#save_data.append_array(int16_to_bytes(HonkCounter.honk_total))
	#save_data.append_array(int16_to_bytes(Stopwatch.get_seconds()))

func write_data() -> bool:
	return true

func read_data() -> bool:
	
	if quest_state_valid() and planet_id_valid():
		return true
	# state validation failed
	return false
	
func quest_state_valid() -> bool:
	var questplaceholder : int # placeholder
	return not BAD_QUEST_BYTES.has(questplaceholder)


func planet_id_valid() -> bool:
	var planetplaceholder : int # placeholder
	return planetplaceholder < 23

## get a snapshot of the visibility of map elements, then serialize to binary
func get_map_state() -> PackedByteArray:
	for child in get_tree().get_nodes_in_group(&"Map_Elements"):
		map_visibility[child.name] = child.visible
	return var_to_bytes(map_visibility)


func set_map_state() -> void:
	for child in get_tree().get_nodes_in_group(&"Map_Elements"):
		child.visible = map_visibility[child.name]


func set_quest_state() -> void:
	pass
