extends VBoxContainer

var audio_bus_indicies : Dictionary[String, int] = {
}

const bus_name_overrides : Array[String]= [] 	# override internal bus names here in bus order, but will break if total buses changes during runtime
const min_slider_size : Vector2 = Vector2(300.0,50.0)

var temp_slider : HSlider
var temp_slider_label : Label

func set_base_slider_attributes(slider : HSlider) -> void:
	slider.custom_minimum_size = min_slider_size
	slider.scrollable = false
	slider.max_value = 1.0
	slider.step = 0.05

func bus_setup() -> void:
	var bus_name : StringName
	var slider_name : StringName
	assert(bus_name_overrides.is_empty() || AudioServer.bus_count == bus_name_overrides.size(), 
		"Bus name overrides array is set, but number of overrides does not match total buses.")
	for bus in AudioServer.bus_count:
		bus_name = AudioServer.get_bus_name(bus)
		slider_name = bus_name + "AudioSlider"
		temp_slider = HSlider.new()
		temp_slider_label = Label.new()
		set_base_slider_attributes(temp_slider)
		
		# add the bus to the bus index dictionary
		audio_bus_indicies[bus_name] = bus
		
		# set base audio value
		temp_slider.value = AudioServer.get_bus_volume_linear(bus)
		
		# name nodes and set label
		if bus_name_overrides.is_empty():
			temp_slider.set_name(slider_name)
			temp_slider_label.set_name(bus_name + "AudioLabel")
			temp_slider_label.text = bus_name
		else:
			temp_slider.set_name(bus_name_overrides[bus] + "AudioSlider")
			temp_slider_label.set_name(bus_name_overrides[bus] + "AudioLabel")
			temp_slider_label.text = bus_name_overrides[bus]
			
		# add nodes to tree
		add_child(temp_slider)
		temp_slider.add_child(temp_slider_label)
		
		# connect signals
		temp_slider.value_changed.connect(_on_any_value_changed, CONNECT_APPEND_SOURCE_OBJECT )

func _ready() -> void:
	bus_setup() # sanity check

func _on_any_value_changed(new_volume: float, source : Object):
	var bus_index : int = audio_bus_indicies[source.get_child(0).text]
	AudioServer.set_bus_volume_linear(bus_index, new_volume)

func _on_any_mouse_exited() -> void:
	release_focus()
