extends VBoxContainer

const audio_bus_indicies : Dictionary[String, int] = {
	Master =  0,
	Music = 1,
	Sfx = 2,
}
const master_bus : int = 0
const music_bus : int = 1
const sfx_bus : int = 2
const num_buses : int = 3
const bus_name_overrides : Array[String]= [] 	# override internal bus names here in bus order
												# this depends on the number of buses not changing during runtime
const min_slider_size : Vector2 = Vector2(300.0,50.0)

var temp_slider : HSlider
var temp_slider_label : Label

@onready var master_slider : HSlider = $MasterAudioSlider
@onready var music_slider : HSlider = $MusicAudioSlider
@onready var sfx_slider : HSlider = $SfxAudioSlider

func set_base_slider_attributes(slider : HSlider) -> void:
	slider.custom_minimum_size = min_slider_size
	slider.scrollable = false
	slider.Range.max_value = 1.0
	slider.Range.step = 0.05

func bus_setup() -> void:
	var bus_name : StringName
	var slider_name : StringName
	var bus_index : int
	assert(bus_name_overrides.is_empty() || AudioServer.bus_count == bus_name_overrides.size(), 
		"Bus name overrides array is set, but number of overrides does not match total buses.")
	for bus in AudioServer.bus_count:
		bus_name = AudioServer.get_bus_name(bus)
		slider_name = bus_name + "AudioSlider"
		temp_slider = HSlider.new()
		temp_slider_label = Label.new()
		set_base_slider_attributes(temp_slider)
		
		# set base audio value
		temp_slider.value = AudioServer.get_bus_volume_linear(bus)
		
		# name nodes
		if bus_name_overrides.is_empty():
			temp_slider.set_name(slider_name)
			temp_slider_label.set_name(bus_name)
		else:
			temp_slider.set_name(bus_name_overrides[bus] + "AudioSlider")
			temp_slider_label.set_name(bus_name_overrides[bus] + "AudioLabel")
			
		# add nodes to tree
		add_child(temp_slider)
		temp_slider.add_child(temp_slider_label)
		
		# connect signals
		temp_slider.value_changed.connect(_on_any_value_changed)
		


func _ready() -> void:
	bus_setup() # sanity check

	# setting built-in property Range.value
	#master_slider.value = AudioServer.get_bus_volume_linear(master_bus)
	#music_slider.value = AudioServer.get_bus_volume_linear(music_bus)
	#sfx_slider.value = AudioServer.get_bus_volume_linear(sfx_bus)

func _on_any_value_changed(new_volume: float, slider : HSlider):
	

func _on_master_value_changed(new_volume: float) -> void:
	AudioServer.set_bus_volume_linear(master_bus, new_volume)
	
func _on_music_value_changed(new_volume: float) -> void:
	AudioServer.set_bus_volume_linear(music_bus, new_volume)

func _on_sfx_value_changed(new_volume: float) -> void:
	AudioServer.set_bus_volume_linear(sfx_bus, new_volume)
	
func _on_any_mouse_exited() -> void:
	release_focus()
