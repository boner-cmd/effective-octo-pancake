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

var save_data : PackedByteArray = [0]
# load_data is separate from save_data for debugging convenience
var load_data : PackedByteArray
var trigger_load : bool = false

#func _ready() -> void:
	## TODO resize save_data to the exact length it needs to be and add data by index instead of using
	## append()
	#save_data.resize(4)


func save_game():
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

	# map state, bytes 12 - 1923
	save_data.append_array(get_map_state())

	if not write_data(save_data):
		print("write failed")


func write_data(d : PackedByteArray) -> bool:
	var compressed_data : PackedByteArray = d.compress(FileAccess.COMPRESSION_GZIP)
	var file : FileAccess = FileAccess.open("user://Attentive_Helper_Data.dat", FileAccess.WRITE)
	return file.store_buffer(compressed_data)


func read_data() -> bool:
	# can remove the below comment if get_file_as_bytes works
	#var file : FileAccess = FileAccess.open("user://Attentive_Helper_Data.dat", FileAccess.READ)
	var compressed_data : PackedByteArray = FileAccess.get_file_as_bytes("user://Attentive_Helper_Data.dat")
	# TODO once the max size of the decompressed data is confirmed, can use decompress() with a fixed buffer size
	var decompressed_data : PackedByteArray = compressed_data.decompress_dynamic(-1, FileAccess.COMPRESSION_GZIP)
	if FileAccess.get_open_error():
		print("File access failed")
		return false
	#if not quest_state_valid():
		#print("Quest state validation failed")
		#return false
	#if not planet_id_valid():
		#print("Planet ID validation failed")
		#return false
	load_data = decompressed_data
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

		get_tree().get_first_node_in_group("Main").on_planet_change_requested(load_data[1])
		HonkCounter.honk_total = load_data.decode_s16(2)
		Stopwatch.seconds_elapsed = load_data.decode_s16(4)
		QuestManager.states = load_data.slice(6, 12)
		set_map_state(load_data.slice(12))

	else:
		print("read failed")


## get a snapshot of the visibility of map elements, then serialize to binary
func get_map_state() -> PackedByteArray:
	var map_visibility : Dictionary[StringName, bool]
	for child in get_tree().get_nodes_in_group(&"Map_Elements"):
		map_visibility[child.name] = child.visible
	print(map_visibility)
	return var_to_bytes(map_visibility)


## @experimental this might error if there are map elements in the current SceneTree that aren't 
## represented in the loaded game map state dictionary. Since map content isn't dynamically created, 
## this shouldn't occur, but it is possible.
func set_map_state(b : PackedByteArray) -> void:
	var map_visibility : Dictionary[StringName, bool] = bytes_to_var(b)
	var map_elements : Array[Node] = get_tree().get_nodes_in_group(&"Map_Elements")
	for child in map_elements:
		child.visible = map_visibility[child.name]


func set_quest_state() -> void:
	pass


func _on_request_check_load() -> void:
	if trigger_load:
		restore_state()
		trigger_load = false


### @experimental not implemented yet
#func quest_state_valid() -> bool:
	#var questplaceholder : int # placeholder
	#return not BAD_QUEST_BYTES.has(questplaceholder)


### @experimental not implemented yet 
#func planet_id_valid() -> bool:
	#var planetplaceholder : int # placeholder
	#return planetplaceholder < 23
