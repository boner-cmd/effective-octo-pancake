extends MarginContainer
@onready var label: Label = $MarginContainer/Label

func enter_tween():
	await get_tree().create_timer(.8).timeout
	#var tween_nametag = get_tree().create_tween()
	#var tweener_nametag = tween_nametag.tween_property(self, "scale:y",  1.0, .2)
	#tweener_nametag.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	#tween_nametag.play()
	self.scale.y = 1.0
	var tween_label = get_tree().create_tween()
	var tweener_label = tween_label.tween_property(label, "self_modulate:a",  1.0, .2)
	tweener_label.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween_label.play()
	await tween_label.finished
	#if tween_nametag and tween_nametag.is_valid():
		#tween_nametag.kill()
	if tween_label and tween_label.is_valid():
		tween_label.kill()


func exit_tween():
	#var tween_nametag = get_tree().create_tween()
	#var tweener_nametag = tween_nametag.tween_property(self, "scale:y",  0.001, .2)
	#tweener_nametag.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	#tween_nametag.play()
	var tween_label = get_tree().create_tween()
	var tweener_label = tween_label.tween_property(self, "modulate:a",  0.0, .2)
	tweener_label.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween_label.play()
	await tween_label.finished
	#if tween_nametag and tween_nametag.is_valid():
		#tween_nametag.kill()
	if tween_label and tween_label.is_valid():
		tween_label.kill()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.self_modulate.a = 0.0
	label.scale.y = 0.0
	enter_tween()
