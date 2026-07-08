extends Node

# TODO implement validation of read data
### all invalid values on a byte basis that would contain a two-bit pair of 10 for any quest state
### in other words, the decimal digits provided correspond to all values of the pattern:
### 0b10, (2)
### 0b10XX, (8 - 11)
### 0b10XXXX, (32 - 47)
### 0b10XXXXXX. (128 - 191)
#const BAD_QUEST_BYTES : PackedByteArray = [
	#2, 8, 9, 10, 11, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 128, 129, 130, 
	#131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 
	#150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 
	#169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 
	#188, 189, 190, 191,
	#]

var main : Node3D
var inventory_control : Control

# load_data is separate from save_data for debugging convenience
var load_data : PackedByteArray
var save_data : PackedByteArray

var trigger_load : bool = false
var test : bool = false

# TODO resize save_data to the exact length it needs to be and add data by index instead of using
# append()
#func _ready() -> void:
	#save_data.resize(4)


func save_game():
	save_data = [0]
	# temporary variable to hold the results of encoding
	var encode_placeholder : PackedByteArray = [0,0]
	# lock logic occupies one nybble of byte 0
	# horse lock: byte 0, bit 0
	# gate lock: byte 0, bit 1
	# sisyphus lock: byte 0, bit 2
	# king_2 lock: byte 0, bit 3
	if DialogueManager.horse_lock:
		save_data[0] |= 0b1111 # if the horse door is locked, all other locks must be locked
	elif DialogueManager.gate_lock:
		save_data[0] |= 0b1110 # if gate is locked and horse is unlocked, all others must be locked
	elif DialogueManager.sisyphus_lock:
		save_data[0] |= 0b1100
	elif DialogueManager.king2_lock:
		save_data[0] |= 0b1000

	# current planet ID, byte 1
	save_data.append(get_tree().get_first_node_in_group("Main").current_planet_id)

	# honks, byte 2 and 3
	encode_placeholder.encode_s16(0, HonkCounter.honk_total)
	save_data.append_array(encode_placeholder)
	encode_placeholder = [0,0]

	# time in seconds, byte 4 and 5
	encode_placeholder.encode_s16(0, Stopwatch.get_seconds())
	save_data.append_array(encode_placeholder)
	encode_placeholder = [0,0]

	# quest data, bytes 6 - 11
	save_data.append_array(QuestManager.states)

	# inventory state, bytes 12-14
	var inventory_dict : Dictionary[StringName, int] = get_tree().get_first_node_in_group("Inventory").inventory_slots
	save_data.append(inventory_dict.values()[0])
	save_data.append(inventory_dict.values()[1])
	save_data.append(inventory_dict.values()[2])

	# map state, bytes 15 - 1939
	# TODO verify that map state is of consistent size
	save_data.append_array(get_map_state())

	if not write_data(save_data):
		print("write failed")


func write_data(d : PackedByteArray) -> bool:
	#print(d.size())
	var save_compressed_data : PackedByteArray = d.compress(FileAccess.COMPRESSION_GZIP)
	var file : FileAccess = FileAccess.open("user://Attentive_Helper_Data.dat", FileAccess.WRITE)
	var success : bool = file.store_buffer(save_compressed_data)
	file.close()
	return success


func read_data() -> bool:
	var load_file : FileAccess = FileAccess.open("user://Attentive_Helper_Data.dat", FileAccess.READ)
	if FileAccess.get_open_error():
		print("File access failed")
		return false
	var load_compressed_data : PackedByteArray = load_file.get_buffer(load_file.get_length())
	# TODO verify that the buffer size is correct
	var decompressed_data : PackedByteArray = load_compressed_data.decompress(2499, FileAccess.COMPRESSION_GZIP)
	
	#if not quest_state_valid():
		#print("Quest state validation failed")
		#return false
	#if not planet_id_valid():
		#print("Planet ID validation failed")
		#return false
		
	load_data = decompressed_data
	load_file.close()
	return true


func restore_state() -> void:
	if read_data():
		if load_data[0] & 0b1:
			DialogueManager.horse_lock = true
			DialogueManager.gate_lock = true
			DialogueManager.sisyphus_lock = true
			DialogueManager.king2_lock = true
		elif load_data[0] & 0b10:
			DialogueManager.horse_lock = false
			DialogueManager.gate_lock = true
			DialogueManager.sisyphus_lock = true
			DialogueManager.king2_lock = true
		elif load_data[0] & 0b100:
			DialogueManager.horse_lock = false
			DialogueManager.gate_lock = false
			DialogueManager.sisyphus_lock = true
			DialogueManager.king2_lock = true
		elif load_data[0] & 0b1000:
			DialogueManager.horse_lock = false
			DialogueManager.gate_lock = false
			DialogueManager.sisyphus_lock = false
			DialogueManager.king2_lock = true
		
		main = preload("res://Scenes/MainScene.tscn").instantiate()
		main.request_ready()
		if load_data[1] == 21:
			main.current_planet_id = 0
		else:
			main.current_planet_id = load_data[1]
		get_tree().root.add_child(main)
		
		HonkCounter.honk_total = load_data.decode_s16(2)
		Stopwatch.seconds_elapsed = load_data.decode_s16(4)
		QuestManager.states = load_data.slice(6, 12)
		set_map_state(load_data.slice(15))
		
		inventory_control = main.hud_overlay.inventory
		if load_data[12]: inventory_control.add_item(load_data[12])
		if load_data[13]: inventory_control.add_item(load_data[13])
		if load_data[14]: inventory_control.add_item(load_data[14])
		get_node("/root/TitleScreen").free()

	else:
		print("read failed")


## get a snapshot of the visibility of map elements, then serialize to binary
func get_map_state() -> PackedByteArray:
	var map_visibility : Dictionary[StringName, bool]
	for child in get_tree().get_nodes_in_group(&"Map_Elements"):
		map_visibility[child.name] = child.visible
	return var_to_bytes(map_visibility)


## @experimental this might error if there are map elements in the current SceneTree that aren't 
## represented in the loaded game map state dictionary. Since map content isn't dynamically created, 
## this shouldn't occur, but it is possible.
func set_map_state(b : PackedByteArray) -> void:
	var map_visibility : Dictionary[StringName, bool] = bytes_to_var(b)
	#print(map_visibility)
	var map_elements : Array[Node] = get_tree().get_nodes_in_group(&"Map_Elements")
	for child in map_elements:
		child.visible = map_visibility[child.name]

func check_load() -> void:
	if trigger_load:
		restore_state()
		trigger_load = false
	else:
		get_node(^"/root/TitleScreen").free()
		main = preload("res://Scenes/MainScene.tscn").instantiate()
		get_tree().root.add_child(main)


### @experimental not implemented yet
#func quest_state_valid() -> bool:
	#var questplaceholder : int # placeholder
	#return not BAD_QUEST_BYTES.has(questplaceholder)


### @experimental not implemented yet 
#func planet_id_valid() -> bool:
	#var planetplaceholder : int # placeholder
	#return planetplaceholder < 23
