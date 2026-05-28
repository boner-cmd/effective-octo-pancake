extends Node

## The original states array of Int64s is stored for reference.
## @deprecated: for speed and efficiency, old_states should not be used, and is only temporarily
## retained until final removal. Instead, [states] should be used.
#const old_states : Array[int] = [
	#0b00010010000000000000010000000000000000000000000000,
	#0b01010001000000000000000000000000000000000000001000,
	#0b01010001000000000000000000000000000100000000000000, #Astronaut
	#0b01010001000000000000000000000000000000000000000100,
	#0b01000001000000000000000000000001000000000000000000,
	#0b00010000000000000000000000000000000000000000000000,
	#0b01010001000000000000000000000000000000000100000000, # Deer
	#0b01000001000000000000000000000000000000000000000001, # Gate
	#0b01010001000000000000000000000000010000000000000000,
	#0b00010000000000000000000000000000000000000000000000,
	#0b00010010010000010000000000000000000000000000000000,
	#0b01010001000000000000000000000000100000000000000000, #
	#0b01000001000000000000000000000000000000001000000000, # Norgans depends on Organs
	#0b01010001000000000000000000000000000000010000000000,
	#0b01010001000000000000000000000000000000000000100000,
	#0b01010001000000000000000000000000000000100000000000,
	#0b01010001000000000000000000000000000000000000000010, # Gibberish
	#0b01010001000000000000000000000000000000000001000000, # Idea depends on Deer?
	#0b00010001000000000000000000000000001001000000000000, # Bohdi - broken
	#0b01010001000000000000000000000000000010000000000000, # updated to reflect that mould gives item
	#0b01000001000000000000000000000010000000000000000000, # updated to reflect that king2 receives item
#]	

## The original planet ID to NPC name dictionary is stored for reference.
## @deprecated: planet IDs should not be mapped to names, and instead enum ordering should be used
## to eliminate an unnecessary lookup
#const planet_id_by_npc_name : Dictionary[String, int] = {
	#King 		= 1,
	#Horse 		= 2,
	#Astronaut 	= 3,
	#Snowman 	= 4,
	#Sisyphus 	= 17,
	#Grease 		= 7,
	#Deer 		= 10,
	#Gate 		= 5,
	#O 			= 9,
	#Organs 		= 15,
	#Mass 		= 18,
	#Lamp 		= 12,
	#Norgans 	= 14,
	#Michaelwave = 19,
	#Robot 		= 6,
	#Individual 	= 13,
	#Gibberish 	= 8,
	#Idea 		= 11,
	#Bodhi 		= 16,
	#Slime 		= 20,
	#King2 		= 21
#}

## The main_quest_completed signal is used to determine if Slime Mould, the second-to-last character,
## has had their quest completed. This is used to stamp the stickerbook complete and prepare the 
## endgame meeting with KING_2.
signal main_quest_completed()

## CharacterName represents the canonical "order" of NPCs whenever a sequential ID is required.
## CharacterName values can be transformed into bit IDs with the function 2**CharacterName, and
## transformed back using log(bit_ID)/log(2), where log in Godot represents the natural log (ln)
## @experimental: TODO planet IDs must be changed to match CharacterName order. Additionally, some
## efficiency is wasted if the enum's corresponding values are Int64s. The hope is that Int64s in
## the worst case are still superior in size and handling to Strings. However, if StringNames are
## significantly more memory-efficient than Int64s, then another handling may be superior.
enum CharacterName {
	KING_1,
	HORSE,
	ASTRO,
	SNOWMAN,
	SISYPHUS,
	GREASE,
	DEER,
	GATE,
	O,
	ORGANS,
	MASS,
	LAMP,
	NORGANS,
	MICHAEL,
	ROBOT,
	INDIVIDUAL,
	GIBBERISH,
	IDEA,
	BODHI,
	SLIME,
	KING_2,
}

## MEETING_REQS stores the combined character bit IDs of each meeting dependency, indexed
## in CharacterName order.
## @experimental: Ideally, this constant will be compressed from 21 Int32s, nearly all of which are 
## 0, to only the few non-zero Int32s of data plus one additional Int32 representing correspondence
## to characters. However, the previous attempt at creating that logic without resorting to Int64s 
## was dense and unoptimized relative to simply retaining the unused 0-value Int32s as padding.
## Using this transitional constant is still more efficient than the previous fully-variable 
## Array[Int64].
const MEETING_REQS : PackedInt32Array = [
	0b000000000000010000000,
	0b000000000000000000000,
	0b000000000000000000000,
	0b000000000000000000000,
	0b000000000000000000000,
	0b000000000000000000000,
	0b000000000000000000000,
	0b000000000000000000000,
	0b000000000000000000000,
	0b000000000000000000000,
	0b010000010000000000000,
	0b000000000000000000000,
	0b000000000000000000000,
	0b000000000000000000000,
	0b000000000000000000000,
	0b000000000000000000000,
	0b000000000000000000000,
	0b000000000000000000000,
	0b000000000000000000000,
	0b000000000000000000000,
	0b000000000000000000000,
]

## COMPLETION_REQS stores the combined character bit IDs of each completion dependency, indexed
## in CharacterName order.
## @experimental: Ideally, this constant will be compressed from 21 Int32s, some of which are 0, to 
## only non-zero Int32s of data plus one additional Int32 representing correspondence to characters.
## However, the previous attempt at creating that logic without resorting to Int64s was dense and 
## unoptimized relative to simply retaining the unused 0-value Int32s as padding. Using this 
## transitional constant is still more efficient than the previous fully-variable Array[Int64].
const COMPLETION_REQS : PackedInt32Array = [
	0b000000000000000000000,
	0b000000000000000001000,
	0b000000100000000000000,
	0b000000000000000000100,
	0b001000000000000000000,
	0b000000000000000000000,
	0b000000000000100000000,
	0b000000000000000000001,
	0b000010000000000000000,
	0b000000000000000000000,
	0b000000000000000000000,
	0b000100000000000000000,
	0b000000000001000000000,
	0b000000000010000000000,
	0b000000000000000100000,
	0b000000000100000000000,
	0b000000000000000000010,
	0b000000000000001000000,
	0b000001001000000000000,
	0b000000010000000000000,
	0b010000000000000000000,
]

## tl;dr this array maps a CharacterName's numeric equivalent, as the the array index i, to a bit
## ID b such that the output of (log(b)/log(2)) = i, where log() is the natural log function.[br]
## [br]
## QuestManager sometimes needs to map bit IDs, which are indexed by highest bit order, and enum
## CharacterName integer equivalents. For example, it is desirable to exchange between the bit ID 
## 0b1000, and the corresponding CharacterName 3, where 3 is the 4th number in a zero-indexed series. 
## Since 2 ** 3 = 8 (0b1000), the naive way to reverse the process would be to take log2(8).
## However, since Godot does not support logarithms with arbitrary bases and the log() function 
## represents the natural log ln() in Godot, this means that calculating log2(8) requires 
## ln(8)/ln(2), which are two floating point operations followed by division. Even though log2() 
## operations on a CPU should be fast, it is unclear if there is optimization for ln(x)/ln(2), and 
## such optimizations would be platform-dependent. To sidestep this issue, LOG_2_TABLE provides the 
## hardcoded solution to log2(b) for values of b up to 2 ** 21, which is the highest used by the
## game.
const LOG_2_TABLE : PackedInt32Array = [
	0b1,
	0b10,
	0b100,
	0b1000,
	0b10000,
	0b100000,
	0b1000000,
	0b10000000,
	0b100000000,
	0b1000000000,
	0b10000000000,
	0b100000000000,
	0b1000000000000,
	0b10000000000000,
	0b100000000000000,
	0b1000000000000000,
	0b10000000000000000,
	0b100000000000000000,
	0b1000000000000000000,
	0b10000000000000000000,
	0b100000000000000000000,
]
  
## states stores two-bit state information pairs packed into bytes. Bit pairs are addressed from 
## right to left (LSB to MSB). The first bit of each pair, the right bit (0b01 or its equivalent 0b1),
## represents if a character has been met. The second bit of each pair, the left bit (0b10),
## represents if a character's quest has been completed. Instead of trying to access or manipulate 
## the array directly, use has_met() and has_completed(), or set_met() and set_completed(),
## respectively.
var states : PackedByteArray = [
	0b00000000,
	0b00000000,
	0b00000000,
	0b00000000,
	0b00000000, 
	0b00, # six bits of unused padding
]


## has_met uses integer division and modulo arithmatic to unpack the bit pairs in the PackedByteArray
## states. has_met takes a CharacterName enum as input and returns a boolean. The CharacterName enum 
## ensures access by character proceeds in canonical character order.[br]
## character / 4 yields the array index of the desired byte.[br]
## (character % 4) * 2 yields the index of the bit pair to check.[br]
## To access the bit pair, the byte is shifted to the right by the index to move the desired pair 
## into the least significant bits of the byte. To test for meeting, the bit pair is matched to 0b1 
## using bitwise and to see if the right bit is 1, representing "true."
func has_met(character : CharacterName) -> bool:
	@warning_ignore("integer_division")
	return states[character / 4] >> (character % 4) * 2 & 0b1


## has_completed uses integer division and modulo arithmatic to unpack the bit pairs in the 
## PackedByteArray states. has_met takes a CharacterName enum as input and returns a boolean. The 
## CharacterName enum ensures access by character proceeds in canonical character order.[br]
## character / 4 yields the array index of the desired byte.[br]
## (character % 4) * 2 yields the index of the bit pair to check.[br]
## To access the bit pair, the byte is shifted to the right by the index to move the desired pair 
## into the least significant bits of the byte. To test for completion, the bit pair is matched to
## 0b10 using bitwise and to see if the left bit is 1, representing "true."
func has_completed (character : CharacterName) -> bool:
	# character / 4 gives byte index
	# (character % 4) * 2 gives bit pair index
	# checking left bit (hasCompleted)
	@warning_ignore("integer_division")
	return states[character / 4] >> (character % 4) * 2 & 0b10


## set_met uses the same unpacking and indexing code as has_met, but instead of using bitwise and a
## right shift read the right (0b1) bit, it uses bitwise or with the or-equals operator to set
## the bit, after shifting the bit left by the bit index to align with the relevant position within
## the byte.
func set_met(character : CharacterName) -> void:
	@warning_ignore("integer_division")
	states[character / 4] |= 0b1 << (character % 4) * 2


## set_completed uses the same unpacking and indexing code as has_met, but instead of using bitwise and a
## right shift read the left (0b10) bit, it uses bitwise or with the or-equals operator to set
## the bit, after shifting the bit left by the bit index to align with the relevant position within
## the byte.
func set_completed(character : CharacterName) -> void:
	@warning_ignore("integer_division")
	states[character / 4] |= 0b10 << (character % 4) * 2


## completion_satisfied checks to see if any bits are set to 1 in the COMPLETION_REQS array index
## corresponding to the provided CharacterName. If so, it finds the number of significant bits in
## the completion bits, then iterates over them to find the position of each bit set to 1. When a
## bit is found, the function uses LOG_2_TABLE to correlate the bit ID with its corresponding
## CharacterName, then uses that numeric representation of the CharacterName to call has_completed
## and returns true or false accordingly.
func completion_satisfied(character : CharacterName) -> bool:
	if COMPLETION_REQS[character]:
		for i in LOG_2_TABLE.bsearch(COMPLETION_REQS[character]) + 1:
			if COMPLETION_REQS[character] & (2 ** i): # if there is a 1 in bit position 2 ** i
				if not has_completed(LOG_2_TABLE.bsearch(2 ** i)):
					return false
	return true


## meeting_satisfied checks to see if any bits are set to 1 in the MEETING_REQS array index
## corresponding to the provided CharacterName. If so, it finds the number of significant bits in
## the meeting bits, then iterates over them to find the position of each bit set to 1. When a
## bit is found, the function uses LOG_2_TABLE to correlate the bit ID with its corresponding
## CharacterName, then uses that numeric representation of the CharacterName to call has_met
## and returns true or false accordingly.
func meeting_satisfied(character : CharacterName) -> bool:
	if MEETING_REQS[character]:
		for i in LOG_2_TABLE.bsearch(MEETING_REQS[character]) + 1:
			if MEETING_REQS[character] & (2 ** i):
				if not has_met(LOG_2_TABLE.bsearch(2 ** i)):
					return false
	return true


## requirements_met is a combination of completion_satisfied and meeting_satisfied. It exists solely
## to allow the separation of the two checks for readability.
func requirements_met(character : CharacterName) -> bool:
	# an NPC who has their requirements met is ready to give, receive, or exchange an item on next interact
	return meeting_satisfied(character) and completion_satisfied(character)


## TODO placeholder documentation
func stamp_completion() -> void:
	assert(has_completed(CharacterName.SLIME), "stamp_completion should not be called until Slime Mould's quest is complete.")
	main_quest_completed.emit()
