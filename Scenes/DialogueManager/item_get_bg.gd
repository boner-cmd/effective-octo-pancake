extends Sprite3D
@onready var player_receive: Camera3D = %player_receive
@onready var timer: Timer = $"../Timer"
var icon_state : int = 0


func animate() -> void:
	if timer.is_stopped():
		timer.start(.5)
		if player_receive.current:
			visible = true
			match icon_state:
				0:
					flip_h = true
					flip_v = false
					icon_state += 1
				1:
					flip_h = true
					flip_v = true
					icon_state += 1
				2:
					flip_h = false
					flip_v = true
					icon_state += 1
				3:
					flip_h = false
					flip_v = false
					icon_state = 0
		else:
			reset()

func reset() -> void:
	timer.stop()
	visible = false
	flip_h = false
	flip_v = false
