extends Area3D

@onready var CanvasLayer_in: CanvasLayer = %CanvasLayer
@onready var interact_ui : MarginContainer = %interact

var talking : bool = false

# Tracks the current object the player is overlapping with
var current_interactable: Object = null
var interaction_label: Object = null

func _ready() -> void:
	# Connect the area signals to handle detection
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and current_interactable:
		current_interactable.interact()
		talking = true
		interact_ui.visible = false

func _on_area_entered(area: Area3D) -> void:
	current_interactable = area
	CanvasLayer_in = area.Canvas
	interact_ui = area.interact_ui
	if !talking:
		interact_ui.visible = true
	else:
		interact_ui.visible = false

func _on_area_exited(area: Area3D) -> void:
	if current_interactable == area:
		current_interactable = null
		interact_ui.visible = false
		talking = false
