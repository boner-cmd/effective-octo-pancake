extends Node3D
@onready var door_credits: Node3D = $"../../../Door_Credits"
@onready var credits_door_locator: Node3D = $Credits_Door_Locator
@export var debug_victory = false

func on_completion():
	if QuestManager.has_completed(QuestManager.CharacterName.KING_2):
		door_credits.global_transform = credits_door_locator.global_transform
		door_credits.visible = true

func _ready() -> void:
	if QuestManager.has_completed(QuestManager.CharacterName.KING_2):
		door_credits.global_transform = credits_door_locator.global_transform
		door_credits.visible = true
		door_credits.get_child(0).stasis()
	if debug_victory:
		door_credits.global_transform = credits_door_locator.global_transform
		door_credits.visible = true
