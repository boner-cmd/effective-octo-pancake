extends TextureRect

const Q_PLANET_ICON = preload("uid://dcjo5apqe7h1q")
#planets should be set visible = true, first child is completion sticker vis = false set true on completion
@onready var position_marker: TextureRect = $PositionMarker
@onready var Position_by_Int : Array = [
	Vector2(588.0, 270.0),	#king_sticker,
	Vector2(446.0, 371.0),	#horse_sticker,
	Vector2(421.0, 186.0),	#astro_sticker,
	Vector2(697.0, 388.0),	#snow_sticker,
	Vector2(255.0, 428.0),	#sisyphus_sticker,
	Vector2(518.0, 65.0),	#grease_sticker,
	Vector2(243.0, 100.0),	#deer_sticker,
	Vector2(761.0, 205.0),	#gate_sticker,
	Vector2(676.0, 547.0),	#o_sticker,
	Vector2(253.0, 253.0),	#organs_sticker,
	Vector2(100.0, 185.0),	#mass_sticker,
	Vector2(817.0, 600.0),	#lamp_sticker,
	Vector2(469.0, 561.0),	#norgans_sticker,
	Vector2(866.0, 424.0),	#michaelwave_sticker,
	Vector2(892.0, 283.0),	#robot_sticker,
	Vector2(847.0, 76.0),	#individual_sticker,
	Vector2(1079.0, 247.0),	#gibberish_sticker,
	Vector2(1053.0, 430.0),	#idea_sticker,
	Vector2(1080.0, 102.0),	#bodhi_sticker,
	Vector2(140.0, 533.0),	#slime_sticker,
	Vector2(588.0, 270.0),	#king_sticker,
]
@onready var king_sticker: TextureRect = $KingSticker
@onready var horse_sticker: TextureRect = $HorseDarkPlanet/HorseSticker
@onready var astro_sticker: TextureRect = $AstroDarkPlanet/AstroSticker
@onready var snow_sticker: TextureRect = $SnowDarkPlanet/SnowSticker
@onready var sisyphus_sticker: TextureRect = $SisyphusDarkPlanet/SisyphusSticker
@onready var grease_sticker: TextureRect = $GreaseDarkPlanet/GreaseSticker
@onready var deer_sticker: TextureRect = $DeerDarkPlanet/DeerSticker
@onready var gate_sticker: TextureRect = $GateDarkPlanet/GateSticker
@onready var o_sticker: TextureRect = $ODarkPlanet/OSticker

@onready var organs_sticker: TextureRect = $OrgansDarkPlanet/OrgansSticker
@onready var mass_sticker: TextureRect = $MassDarkPlanet/MassSticker
@onready var lamp_sticker: TextureRect = $LampDarkPlanet/LampSticker
@onready var norgans_sticker: TextureRect = $NorgansDarkPlanet/NorgansSticker
@onready var michaelwave_sticker: TextureRect = $MichaelwaveDarkPlanet/MichaelwaveSticker
@onready var robot_sticker: TextureRect = $RobotDarkPlanet/RobotSticker
@onready var gibberish_sticker: TextureRect = $GibberishDarkPlanet/GibberishSticker
@onready var individual_sticker: TextureRect = $IndividualDarkPlanet/IndividualSticker
@onready var idea_sticker: TextureRect = $IdeaDarkPlanet/IdeaSticker
@onready var bodhi_sticker: TextureRect = $BodhiDarkPlanet/BodhiSticker
@onready var slime_sticker: TextureRect = $SlimeDarkPlanet/SlimeSticker

@onready var texture_rect: TextureRect = $TextureRect
@onready var texture_rect_2: TextureRect = $TextureRect2
@onready var texture_rect_3: TextureRect = $TextureRect3
@onready var texture_rect_4: TextureRect = $TextureRect4
@onready var texture_rect_5: TextureRect = $TextureRect5
@onready var texture_rect_6: TextureRect = $TextureRect6
@onready var texture_rect_7: TextureRect = $TextureRect7
@onready var texture_rect_8: TextureRect = $TextureRect8
@onready var texture_rect_9: TextureRect = $TextureRect9
@onready var texture_rect_10: TextureRect = $TextureRect10
@onready var texture_rect_11: TextureRect = $TextureRect11
@onready var texture_rect_12: TextureRect = $TextureRect12
@onready var texture_rect_13: TextureRect = $TextureRect13
@onready var texture_rect_17: TextureRect = $TextureRect17
@onready var texture_rect_14: TextureRect = $TextureRect14
@onready var texture_rect_15: TextureRect = $TextureRect15
@onready var texture_rect_16: TextureRect = $TextureRect16
@onready var texture_rect_18: TextureRect = $TextureRect18
@onready var texture_rect_19: TextureRect = $TextureRect19
@onready var texture_rect_20: TextureRect = $TextureRect20

@onready var Stickers_By_Character_Names : Dictionary[QuestManager.CharacterName, TextureRect] = {
	QuestManager.CharacterName.KING_1 : king_sticker,
	QuestManager.CharacterName.HORSE : horse_sticker,
	QuestManager.CharacterName.ASTRO : astro_sticker,
	QuestManager.CharacterName.SNOWMAN : snow_sticker,
	QuestManager.CharacterName.GREASE : grease_sticker,
	QuestManager.CharacterName.DEER : deer_sticker,
	QuestManager.CharacterName.O : o_sticker,
	QuestManager.CharacterName.ORGANS : organs_sticker,
	QuestManager.CharacterName.MASS : mass_sticker,
	QuestManager.CharacterName.LAMP : lamp_sticker,
	QuestManager.CharacterName.MICHAEL : michaelwave_sticker,
	QuestManager.CharacterName.ROBOT : robot_sticker,
	QuestManager.CharacterName.GIBBERISH : gibberish_sticker,
	QuestManager.CharacterName.IDEA : idea_sticker,
	QuestManager.CharacterName.BODHI : bodhi_sticker,
	QuestManager.CharacterName.SLIME : slime_sticker,
	QuestManager.CharacterName.GATE : gate_sticker,
	QuestManager.CharacterName.KING_2 : king_sticker,
	QuestManager.CharacterName.INDIVIDUAL : individual_sticker,
	QuestManager.CharacterName.NORGANS : norgans_sticker,
	QuestManager.CharacterName.SISYPHUS : sisyphus_sticker,
}
@onready var Stickers_By_Int : Array = [
	king_sticker,
	horse_sticker,
	astro_sticker,
	snow_sticker,
	sisyphus_sticker,
	grease_sticker,
	deer_sticker,
	gate_sticker,
	o_sticker,
	organs_sticker,
	mass_sticker,
	lamp_sticker,
	norgans_sticker,
	michaelwave_sticker,
	robot_sticker,
	individual_sticker,
	gibberish_sticker,
	idea_sticker,
	bodhi_sticker,
	slime_sticker,
	king_sticker,
]
#dark planets should be set to texture = null, never hidden
@onready var horse_dark_planet: TextureRect = $HorseDarkPlanet
@onready var astro_dark_planet: TextureRect = $AstroDarkPlanet
@onready var snow_dark_planet: TextureRect = $SnowDarkPlanet
@onready var sisyphus_dark_planet: TextureRect = $SisyphusDarkPlanet
@onready var grease_dark_planet: TextureRect = $GreaseDarkPlanet
@onready var deer_dark_planet: TextureRect = $DeerDarkPlanet
@onready var gate_dark_planet: TextureRect = $GateDarkPlanet
@onready var o_dark_planet: TextureRect = $ODarkPlanet
@onready var organs_dark_planet: TextureRect = $OrgansDarkPlanet
@onready var mass_dark_planet: TextureRect = $MassDarkPlanet
@onready var lamp_dark_planet: TextureRect = $LampDarkPlanet
@onready var norgans_dark_planet: TextureRect = $NorgansDarkPlanet
@onready var michaelwave_dark_planet: TextureRect = $MichaelwaveDarkPlanet
@onready var robot_dark_planet: TextureRect = $RobotDarkPlanet
@onready var gibberish_dark_planet: TextureRect = $GibberishDarkPlanet
@onready var individual_dark_planet: TextureRect = $IndividualDarkPlanet
@onready var idea_dark_planet: TextureRect = $IdeaDarkPlanet
@onready var bodhi_dark_planet: TextureRect = $BodhiDarkPlanet
@onready var slime_dark_planet: TextureRect = $SlimeDarkPlanet

@onready var DarkPlanets : Array = [
	null,
	horse_dark_planet,
	astro_dark_planet,
	snow_dark_planet,
	sisyphus_dark_planet,
	grease_dark_planet,
	deer_dark_planet,
	gate_dark_planet,
	o_dark_planet,
	organs_dark_planet,
	mass_dark_planet,
	lamp_dark_planet,
	norgans_dark_planet,
	michaelwave_dark_planet,
	robot_dark_planet,
	individual_dark_planet,
	gibberish_dark_planet,
	idea_dark_planet,
	bodhi_dark_planet,
	slime_dark_planet,
	null,
	]

#connection arrays by QuestManager.CharacterName?
@onready var king_connection_array : Array = [
	horse_dark_planet,
	texture_rect,
]

@onready var horse_connection_array : Array = [
	astro_dark_planet,
	snow_dark_planet,
	sisyphus_dark_planet,
	texture_rect_2,
	texture_rect_3,
	texture_rect_4,
	texture_rect_5
]

@onready var sisyphus_connection_array : Array = [
	slime_dark_planet,
	texture_rect_10,
]

@onready var astro_connection_array : Array = [
	grease_dark_planet,
	deer_dark_planet,
	texture_rect_6,
	texture_rect_7,
]

@onready var deer_connection_array : Array = [
	mass_dark_planet,
	organs_dark_planet,
	texture_rect_8,
	texture_rect_9,
]

@onready var snow_connection_array : Array = [
	gate_dark_planet,
	o_dark_planet,
	texture_rect_11,
	texture_rect_14,
]

@onready var gate_connection_array : Array = [
	individual_dark_planet,
	robot_dark_planet,
	texture_rect_15,
	texture_rect_16,
]

@onready var robot_connection_array : Array = [
	idea_dark_planet,
	gibberish_dark_planet,
	texture_rect_18,
	texture_rect_19,
]

@onready var gibberish_connection_array : Array = [
	bodhi_dark_planet,
	texture_rect_20,
]

@onready var o_connection_array : Array = [
	norgans_dark_planet,
	lamp_dark_planet,
	texture_rect_12,
	texture_rect_13,
]

@onready var lamp_connection_array : Array = [
	michaelwave_dark_planet,
	texture_rect_17,
]

@onready var hidden_arrays :  Array = [
	king_connection_array,
	horse_connection_array,
	astro_connection_array,
	snow_connection_array,
	sisyphus_connection_array,
	[],
	deer_connection_array,
	gate_connection_array,
	o_connection_array,
	[],
	[],
	lamp_connection_array,
	[],
	[],
	robot_connection_array,
	[],
	gibberish_connection_array,
	[],
	[],
	[],
	[],
]

func unhide_elements(key):
	if key < 21:
		var array = hidden_arrays[key]
		if array:
			for elements in array:
				elements.visible = true
		var current_dark : TextureRect = DarkPlanets[key]
		if current_dark:
			current_dark.texture = null
		var planet : TextureRect = Stickers_By_Int[key]
		planet.visible = true
		var marker_loc : Vector2 = Position_by_Int[key]
		position_marker.position = marker_loc

func set_completion_sticker(key):
	if key != QuestManager.CharacterName.KING_1:
		var completion_sticker : TextureRect = Stickers_By_Character_Names[key].get_child(0)
		if completion_sticker:
			completion_sticker.visible = true
			completion_sticker.position = Vector2(completion_sticker.position.x + randf_range(-10.0, 10.0), completion_sticker.position.y + randf_range(-10.0, 10.0))
			completion_sticker.rotation_degrees = randf_range(0.0, 360.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	horse_dark_planet.visible = true
	texture_rect.visible = true
	position_marker.position = Position_by_Int[0]
	change_o_sticker()


func change_o_sticker() -> void:
	if QuestManager.has_completed(QuestManager.CharacterName.O):
		o_sticker.texture = Q_PLANET_ICON
