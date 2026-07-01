extends Node3D
@onready var cylinder: MeshInstance3D = $Cylinder
@onready var key : Node3D = $GatekeeperKey

func on_completion():
	if QuestManager.has_completed(QuestManager.CharacterName.GATE):
		cylinder.position.x = 1.4
		key.visible = true
