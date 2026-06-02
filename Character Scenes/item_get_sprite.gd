extends Sprite3D
var scale_goal : float = 0.0
@onready var timer: Timer = $Timer

func item_tween():
	timer.wait_time = 1.0
	var tween_item_get = get_tree().create_tween()
	if scale_goal == 0.0:
		scale_goal = 1.0
		tween_item_get.tween_property(self, "scale:x",  scale_goal, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	else:
		scale_goal = 0.0
		tween_item_get.tween_property(self, "scale:x",  scale_goal, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween_item_get.play()
	await tween_item_get.finished
	if tween_item_get and tween_item_get.is_valid():
		tween_item_get.kill()
