extends Node3D
const LAMP_MATERIAL = preload("uid://ue5ddmq273u8")
@onready var spot_light_3d: SpotLight3D = $SpotLight3D
@onready var torus: MeshInstance3D = $Torus

func on_completion():
	if QuestManager.has_completed(QuestManager.CharacterName.LAMP):
		spot_light_3d.visible = true
		torus.material_override = LAMP_MATERIAL
