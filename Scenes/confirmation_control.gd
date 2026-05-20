extends Control

func _ready() -> void:
	visible = false

func set_default_indicator_state() -> void:
	# assert that "yeah" should be indicated by default
	$"yeahIndicator".visible = true
	$"nahIndicator".visible = false

func _input(event):
	if visible:
		if event.is_action_pressed("down") || event.is_action_pressed("up"):
			$"yeahIndicator".visible = !$"yeahIndicator".visible
			$"nahIndicator".visible = !$"nahIndicator".visible
		if event.is_action_pressed("ui_accept"):
			visible = false
			if $"yeahIndicator".visible:
				$"..".go_to_planet()
			else:
				visible = false
		if event.is_action_pressed("ui_cancel"):
			visible = false

func _on_yeah_button_pressed() -> void:
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$"..".go_to_planet()

func _on_nah_button_pressed() -> void:
	visible = false

func _process(_delta: float) -> void:
	if visible:
		pass
