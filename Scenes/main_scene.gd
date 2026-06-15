extends Node3D
var current_planet_id : int = 0
var current_npc
# CanvasLayer is $HUDOverlay
@onready var hud_overlay: CanvasLayer = $HUDOverlay
@onready var inventory : Control = $HUDOverlay/PauseContainer/Inventory
@onready var map : TextureRect = $HUDOverlay/Map


@onready var Player = %PlayerCharacter
## Current planet is used to manage planet-swapping. It is default-assigned to the first planet to
## ensure that the initial planet is removed after transition.
@onready var current_planet : Node3D = planet_nodes[0]
## TODO convert planet_nodes to use the ResourceLoader with sub-threads
var planet_nodes : Dictionary[int, Node3D] = {
	0 : preload("res://planets/Scenes/01_Kings_Planet.tscn").instantiate(),
	1 : preload("res://planets/Scenes/02_Horse_Planet.tscn").instantiate(),
	2 : preload("res://planets/Scenes/03_Astronaut_Planet.tscn").instantiate(),
	3 : preload("res://planets/Scenes/04_Snowman_Planet.tscn").instantiate(),
	4 : preload("res://planets/Scenes/17_Sisyphus_Planet.tscn").instantiate(),
	5 : preload("res://planets/Scenes/07_GreasePuddle_Planet.tscn").instantiate(),
	6 : preload("res://planets/Scenes/10_Deer_Planet.tscn").instantiate(),
	7 : preload("res://planets/Scenes/05_Gatekeeper_Planet.tscn").instantiate(),
	8 : preload("res://planets/Scenes/09_O_Planet.tscn").instantiate(),
	9 : preload("res://planets/Scenes/15_Organs_Planet.tscn").instantiate(),
	10 : preload("res://planets/Scenes/18_Mass_Planet.tscn").instantiate(),
	11 : preload("res://planets/Scenes/12_Lamp_Planet.tscn").instantiate(),
	12 : preload("res://planets/Scenes/14_Norgans_Planet.tscn").instantiate(),
	13 : preload("res://planets/Scenes/19_Michaelwave_Planet.tscn").instantiate(),
	14 : preload("res://planets/Scenes/06_RustyRobot_Planet.tscn").instantiate(),
	15 : preload("res://planets/Scenes/13_Individual_Planet.tscn").instantiate(),
	16 : preload("res://planets/Scenes/08_Gibberish_Planet.tscn").instantiate(),
	17 : preload("res://planets/Scenes/11_Idea_Planet.tscn").instantiate(),
	18 : preload("res://planets/Scenes/16_Bodhi_Planet.tscn").instantiate(),
	19 : preload("res://planets/Scenes/20_Slime_Planet.tscn").instantiate(),
	20 : preload("res://planets/Scenes/01_Kings_Planet.tscn").instantiate(),
	21 : preload("res://Scenes/victory_scene.tscn").instantiate()
}


## TODO switch to a Dictionary to have different voices per character
#@onready var speech_sound = preload("res://sound fx exports/typewriter2026-05-20_13_26_04.wav")

## TODO placeholder documentation
func _ready() -> void:
	# initial setup for first planet, door, and bgm
	get_tree().root.add_child(planet_nodes[0])
	var initial_door : Node3D = get_tree().get_nodes_in_group("Door_Base").front()
	initial_door.request_planet_change.connect(on_planet_change_requested)
	AudioManager.bgm_cycle(0)
	Stopwatch.start()
	

func on_planet_change_requested(planet_ID : int):
	Player.visible = true
	## DEBUG print the time
	print(Stopwatch.get_time())
	## TODO mention why this is relevant and where it is called from
	current_planet_id = planet_ID #DON'T DELETE THIS EVEN IF IT SEEMS REDUNDANT
	Player.set_process_mode(Node.PROCESS_MODE_INHERIT)
	Player._camera.current = true
	var requested_planet = planet_nodes[planet_ID]
	requested_planet.request_ready() # required to re-roll object locations on planet
	hud_overlay.transition()
	map.unhide_elements(planet_ID)
	AudioManager.bgm_cycle(planet_ID)
	get_tree().root.add_child(requested_planet)
	get_tree().root.remove_child(current_planet)
	current_planet = requested_planet
	if planet_ID < 21:
		current_planet.door_anim_reset()
	DialogueManager.current_npc = planet_ID as QuestManager.CharacterName
	current_npc = DialogueManager.current_npc
	# try to connect new door signal, whether required or not
	for door in get_tree().get_nodes_in_group("Door_Base"):
		if not door.request_planet_change.is_connected(on_planet_change_requested):
			door.request_planet_change.connect(on_planet_change_requested)
	if planet_ID == 21:
		inventory.visible = false
		Stopwatch.stop()
		print(Stopwatch.get_time())
		planet_nodes[planet_ID].request_ready()
		hud_overlay.transition()
		AudioManager.bgm_cycle(planet_ID)
		Player.set_process_mode(Node.PROCESS_MODE_DISABLED)
		Player.visible = false
		Player._camera.current = false
		hud_overlay.get_child(0).visible = false
		DialogueManager.current_npc = planet_ID as QuestManager.CharacterName
		current_npc = DialogueManager.current_npc
	
	if hud_overlay.interact_Door.visible:
		hud_overlay.immediate_interact_false(hud_overlay.interact_Door)
		
	Player.reset_player()
