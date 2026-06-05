extends Node3D
@onready var door_credits: Node3D = $"../../../Door_Credits"
@onready var credits_door_locator: Node3D = $Credits_Door_Locator
var active : bool = false

func on_completion():
#if statment for king2 completion
	if QuestManager.has_completed(QuestManager.CharacterName.KING_2):
		door_credits.global_transform = credits_door_locator.global_transform
		door_credits.visible = true
		active = true

func _ready() -> void:
	if active:
		door_credits.global_transform = credits_door_locator.global_transform
		door_credits.visible = true
