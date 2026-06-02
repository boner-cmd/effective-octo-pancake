extends Sprite3D
var scale_goal : float = 0.0
@onready var timer: Timer = $Timer
var tween : Tween


func _ready() -> void:
	tween = get_tree().create_tween()

func item_tween():
	timer.wait_time = 1.0
	tween = get_tree().create_tween()
	if scale_goal == 0.0:
		scale_goal = 1.0
		tween.tween_property(self, "scale:x",  scale_goal, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	else:
		scale_goal = 0.0
		tween.tween_property(self, "scale:x",  scale_goal, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.play()
