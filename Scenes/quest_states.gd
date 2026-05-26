extends Node
	# states is 21 rows and 50 columns
	# 21 rows for 20 NPCs because King is represented twice
	
	# col 1: hasMet
	# col 2: receivesItem
	# col 3: playerGaveItem (player -> npc)
	# col 4: givesItem
	# col 5: gavePlayerItem (npc -> player)
	# col 6: questComplete
	# col 7: dependsOnMeetings
	# col 8: dependsOnCompletion (implicitly player obtained desired item)
	
	# cols 9-29  store the 21 bit binary representation of ALL the people who must be met
	# cols 30-50 store the 21 bit binary representation of ALL the quests that must be completed
	
	# states DOES NOT track if quests are required for transit progress in col 7 and 8
	# however, quest completion state can be read to show/unlock hidden/locked doors
var states : Array[int] = [
	0b00010010000000000000010000000000000000000000000000,
	0b01010001000000000000000000000000000000000000001000,
	0b01010001000000000000000000000000000100000000000000,
	0b01010001000000000000000000000000000000000000000100,
	0b01000001000000000000000000000001000000000000000000,
	0b00010000000000000000000000000000000000000000000000,
	0b01010001000000000000000000000000000000000100000000,
	0b01000001000000000000000000000000000000000000000001,
	0b01010001000000000000000000000000010000000000000000,
	0b00010000000000000000000000000000000000000000000000,
	0b00010010010000010000000000000000000000000000000000,
	0b01010001000000000000000000000000100000000000000000,
	0b01000001000000000000000000000000000000000000000000,
	0b01010001000000000000000000000000000000010000000000,
	0b01010001000000000000000000000000000000000000100000,
	0b01010001000000000000000000000000000000100000000000,
	0b01010001000000000000000000000000000000000000000010,
	0b01010001000000000000000000000000000000000001000000,
	0b00010001000000000000000000000000001001000000000000,
	0b01010001000000000000000000000000000010000000000000, # updated to reflect that mould gives item
	0b01000001000000000000000000000010000000000000000000, # updated to reflect that king2 receives item
]

const state_rows_by_short_name = {
	King 		= 0,
	Horse 		= 1,
	Astronaut 	= 2,
	Snowman 	= 3,
	Sisyphus 	= 4,
	Grease 		= 5,
	Deer 		= 6,
	Gate 		= 7,
	O 			= 8,
	Organs 		= 9,
	Mass 		= 10,
	Lamp 		= 11,
	Norgans 	= 12,
	Michaelwave = 13,
	Robot 		= 14,
	Individual 	= 15,
	Gibberish 	= 16,
	Idea 		= 17,
	Bodhi 		= 18,
	Slime 		= 19,
	King2 		= 20,
}

const planet_id_by_npc_name : Dictionary[String, int] = {
	King 		= 1,
	Horse 		= 2,
	Astronaut 	= 3,
	Snowman 	= 4,
	Sisyphus 	= 17,
	Grease 		= 7,
	Deer 		= 10,
	Gate 		= 5,
	O 			= 9,
	Organs 		= 15,
	Mass 		= 18,
	Lamp 		= 12,
	Norgans 	= 14,
	Michaelwave = 19,
	Robot 		= 6,
	Individual 	= 13,
	Gibberish 	= 8,
	Idea 		= 11,
	Bodhi 		= 16,
	Slime 		= 20,
	King2 		= 21
}

const npc_ids_by_name = {
	King 		= 0b1,
	Horse 		= 0b10,
	Astronaut 	= 0b100,
	Snowman 	= 0b1000,
	Sisyphus 	= 0b10000,
	Grease 		= 0b100000,
	Deer 		= 0b1000000,
	Gate 		= 0b10000000,
	O 			= 0b100000000,
	Organs 		= 0b1000000000,
	Mass 		= 0b10000000000,
	Lamp 		= 0b100000000000,
	Norgans 	= 0b1000000000000,
	Michaelwave = 0b10000000000000,
	Robot 		= 0b100000000000000,
	Individual 	= 0b1000000000000000,
	Gibberish 	= 0b10000000000000000,
	Idea 		= 0b100000000000000000,
	Bodhi 		= 0b1000000000000000000,
	Slime 		= 0b10000000000000000000,
	King2 		= 0b100000000000000000000,
}

const meeting_mask 		: int = 0b00000000111111111111111111111000000000000000000000
const completion_mask	: int = 0b00000000000000000000000000000111111111111111111111

signal main_quest_complete()

func has_met(npc_name : String) -> bool:
	var row : int = state_rows_by_short_name[npc_name]
	return states[row] & 0b10000000000000000000000000000000000000000000000000

func is_complete(npc_name : String) -> bool:
	var row : int = state_rows_by_short_name[npc_name]
	return states[row] & 0b00000100000000000000000000000000000000000000000000

#func receives(npc_name : String) -> bool:
	#var row : int = state_rows_by_short_name[npc_name]
	#return states[row] & 0b01000000000000000000000000000000000000000000000000
#
#func gives(npc_name : String) -> bool:
	#var row : int = state_rows_by_short_name[npc_name]
	#return states[row] & 0b00010000000000000000000000000000000000000000000000

func player_already_received_from(npc_name : String) -> bool:
	var row : int = state_rows_by_short_name[npc_name]
	return states[row] & 0b00001000000000000000000000000000000000000000000000

func player_already_gave_to(npc_name : String) -> bool:
	var row : int = state_rows_by_short_name[npc_name]
	return states[row] & 0b00100000000000000000000000000000000000000000000000	

func depends_on_meeting(npc_name : String) -> bool:
	var row : int = state_rows_by_short_name[npc_name]
	return states[row] & 0b00000010000000000000000000000000000000000000000000	

func depends_on_completion(npc_name : String) -> bool: # implicitly, npc_name receives an item
	var row : int = state_rows_by_short_name[npc_name]
	return states[row] & 0b00000001000000000000000000000000000000000000000000	

func set_player_met(npc_name : String) -> void:
	var row : int = state_rows_by_short_name[npc_name]
	states[row] |= 0b10000000000000000000000000000000000000000000000000

func set_player_gave_npc(npc_name : String) -> void:
	var row : int = state_rows_by_short_name[npc_name]
	states[row] |= 0b00100000000000000000000000000000000000000000000000
	
func set_npc_gave_player(npc_name : String) -> void:
	var row : int = state_rows_by_short_name[npc_name]
	states[row] |= 0b00001000000000000000000000000000000000000000000000
	
func set_complete(npc_name : String) -> void:
	var row : int = state_rows_by_short_name[npc_name]
	states[row] = states[row] | 0b00000100000000000000000000000000000000000000000000

func completion_satisfied(npc_name : String) -> bool: # this is a proxy for "player has what NPC needs"
	if depends_on_completion(npc_name):
		var temp_row : int = states[state_rows_by_short_name[npc_name]]
		var found_id : int
		var requirement : String
		temp_row &= completion_mask	# grab the completion bits
		requirement = String.num_int64(temp_row, 2)
		for step in requirement.length():		# iterate over the bits to find 1s
			if requirement[step].to_int(): 		# on each 1, investigate
				found_id = 2**(requirement.length()-(step+1))
				if !is_complete(npc_ids_by_name.find_key(found_id)):
					return false
	return true

func meeting_satisfied(npc_name : String) -> bool: # this is a proxy for "player has met correct prior NPCs"
	if depends_on_meeting(npc_name):
		var temp_row : int = states[state_rows_by_short_name[npc_name]]
		var found_id : int
		var requirement : String
		temp_row &= meeting_mask				# grab the completion bits
		temp_row >>= 21							# offset the bits to the right
		requirement = String.num_int64(temp_row, 2)
		for step in requirement.length():		# iterate over the bits to find 1s
			if requirement[step].to_int(): 		# on each 1, investigate
				found_id = 2**(requirement.length()-(step+1))
				if !has_met(npc_ids_by_name.find_key(found_id)):
					return false
	return true

func requirements_met(npc_name : String) -> bool:
	# an NPC who has their requirements met is ready to give, receive, or exchange an item on next interact
	return meeting_satisfied(npc_name) && completion_satisfied(npc_name)

func stamp_completion() -> void: # call this at the same time that slime mould's quest state is marked completed
	assert(is_complete("Slime"), "stamp_completion should not be called until Slime Mould's quest is complete.")
	main_quest_complete.emit()
