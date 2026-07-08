extends Node3D
@onready var door_credits: Node3D = $"../../../Door_Credits"
@onready var credits_door_locator: Node3D = $Credits_Door_Locator
@export var debug_victory = false

func on_completion():
	if QuestManager.has_completed(QuestManager.CharacterName.KING_2):
		if door_credits.is_inside_tree():
			door_credits.reparent(credits_door_locator)
			door_credits.position = Vector3(0.0, 0.0, 0.0)
			door_credits.rotation = Vector3(0.0, 0.0, 0.0)
			door_credits.reparent($"../../..")
			door_credits.visible = true
