extends Control

func _ready() -> void:
	visible = false

func set_default_indicator_state() -> void:
	# assert that "yeah" should be indicated by default
	get_node(^"yeahIndicator").visible = true
	get_node(^"nahIndicator").visible = false

func _input(event):
	if visible:
		if event.is_action_pressed("down"):
			pass
		if event.is_action_pressed("up"):
			pass
		if event.is_action_pressed("ui_accept"):
			visible = false
			get_node(^"..").go_to_planet()
		if event.is_action_pressed("ui_cancel"):
			visible = false

func _on_yeah_button_pressed() -> void:
	visible = false
	get_node(^"..").go_to_planet()

func _on_nah_button_pressed() -> void:
	visible = false

func _process(_delta: float) -> void:
	if visible:
		pass
