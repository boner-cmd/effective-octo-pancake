extends Area3D

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

func _on_area_entered(area: Area3D) -> void:
	current_interactable = area
	

func _on_area_exited(area: Area3D) -> void:
	if current_interactable == area:
		
		current_interactable = null
	
