extends VBoxContainer

var audio_bus_indicies : Dictionary[String, int] = {
}

const AH_2_REGULAR = preload("uid://bnyf5t008eyns")

const bus_name_overrides : Array[String]= [] 	# override internal bus names here in bus order, but will break if total buses changes during runtime
const min_slider_size : Vector2 = Vector2(300.0,50.0)

var temp_slider : HSlider

@onready var h_slider_1: HSlider = $HSlider1
@onready var h_slider_2: HSlider = $HSlider2
@onready var h_slider_3: HSlider = $HSlider3

@onready var text_material: Resource = preload("res://UI assets/UIShaders/SquiggleTextMaterial_1.tres")
@onready var hover_material: Resource = preload("res://UI assets/UIShaders/SMALL_UI_MATERIAL_5_HSLIDER_HOVER.tres")
@onready var original_material: Resource = h_slider_1.material

var SliderArray : Array = []

var temp_slider_label : Label

func set_base_slider_attributes(slider : HSlider) -> void:
	slider.custom_minimum_size = min_slider_size
	slider.scrollable = false
	slider.max_value = 1.0
	slider.step = 0.05

func bus_setup() -> void:
	var bus_name : StringName
	var slider_name : StringName
	assert(bus_name_overrides.is_empty()  or  AudioServer.bus_count == bus_name_overrides.size(), 
		"Bus name overrides array is set, but number of overrides does not match total buses.")
	for bus in AudioServer.bus_count:
		bus_name = AudioServer.get_bus_name(bus)
		slider_name = bus_name + "AudioSlider"
		temp_slider = SliderArray[bus]
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
		# add_child(temp_slider)
		temp_slider.add_child(temp_slider_label)
		temp_slider_label.add_theme_font_override("font", AH_2_REGULAR)
		temp_slider_label.add_theme_font_size_override("font_size", 40)
		temp_slider_label.position.y -= 20
		temp_slider_label.material = text_material
		# connect signals
		temp_slider.value_changed.connect(_on_any_value_changed, CONNECT_APPEND_SOURCE_OBJECT )
		temp_slider.mouse_entered.connect(_set_hover_material, CONNECT_APPEND_SOURCE_OBJECT)
		temp_slider.mouse_exited.connect(_unset_hover_material, CONNECT_APPEND_SOURCE_OBJECT)

func _ready() -> void:
	SliderArray.append(h_slider_1)
	SliderArray.append(h_slider_2)
	SliderArray.append(h_slider_3)
	bus_setup() # sanity check

func _on_any_value_changed(new_volume: float, source : Object):
	var bus_index : int = audio_bus_indicies[source.get_child(0).text]
	AudioServer.set_bus_volume_linear(bus_index, new_volume)

func _on_any_mouse_exited() -> void:
	release_focus()

func _set_hover_material(source : Object) -> void:
	source.material = hover_material

func _unset_hover_material(source:Object) -> void:
	source.material = original_material
