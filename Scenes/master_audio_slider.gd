extends HSlider

@export var audio_bus_name : String = "Master"
@onready var _bus = AudioServer.get_bus_index(audio_bus_name)

func _ready() -> void:
	value = AudioServer.get_bus_volume_linear(_bus) # setting built-in property Range.value

func _on_value_changed(new_volume: float) -> void:
	AudioServer.set_bus_volume_linear(_bus, new_volume)
	
func _on_mouse_exited() -> void:
	release_focus()
