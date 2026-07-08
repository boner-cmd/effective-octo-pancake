extends Node3D

@onready var q: Node3D = $"../q"
@onready var cubed_planet: Node3D = $"../../../Cubed_Planet"
@onready var cubed_skybox: Node3D = $"../../../CubedSkybox"
@onready var cubed_skybox_2: Node3D = $"../../../CubedSkybox2"
@onready var cubed_planet_2: Node3D = $"../../../Cubed_Planet2"


func on_completion():
	await get_tree().create_timer(.1).timeout
	if QuestManager.has_completed(QuestManager.CharacterName.O):
		visible = false
		q.visible = true
		cubed_planet.visible = false
		cubed_skybox.visible = false
		cubed_planet_2.visible = true
		cubed_skybox_2.visible = true
		DialogueManager.Character_Names[QuestManager.CharacterName.O] = "Q"
		if DialogueManager.name_tag:
			DialogueManager.name_tag.get_child(1).get_child(0).text = "Q"
		var main = get_tree().get_first_node_in_group("Main")
		main.hud_overlay.map.change_o_sticker()


func _ready() -> void:
	on_completion()
