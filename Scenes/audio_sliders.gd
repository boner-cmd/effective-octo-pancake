extends VBoxContainer


@onready var master_bus = AudioServer.get_bus_index("Master")
@onready var music_bus = AudioServer.get_bus_index("Music")
@onready var sfx_bus = AudioServer.get_bus_index("Sfx")
@onready var master_slider : HSlider = $MasterAudioSlider
@onready var music_slider : HSlider = $MusicAudioSlider
@onready var sfx_slider : HSlider = $SfxAudioSlider

func _ready() -> void:
	# setting built-in property Range.value
	master_slider.value = AudioServer.get_bus_volume_linear(master_bus)
	music_slider.value = AudioServer.get_bus_volume_linear(music_bus)
	sfx_slider.value = AudioServer.get_bus_volume_linear(sfx_bus)

func _on_master_value_changed(new_volume: float) -> void:
	AudioServer.set_bus_volume_linear(master_bus, new_volume)
	
func _on_music_value_changed(new_volume: float) -> void:
	AudioServer.set_bus_volume_linear(music_bus, new_volume)

func _on_sfx_value_changed(new_volume: float) -> void:
	AudioServer.set_bus_volume_linear(sfx_bus, new_volume)
	
func _on_any_mouse_exited() -> void:
	release_focus()
