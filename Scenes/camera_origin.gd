extends Node3D

@export var planet : Node3D
@export var player_character : Node3D

var guts

@onready var camera: Camera3D = $Camera3D

@export var speed: float = .8

var player_model

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_model = player_character.get_child(0)
	guts = planet.get_child(1)
	print(guts)
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("spin_left"):
		guts.angular_velocity = Vector3(0.0, 10*delta, 0.0)
	#if Input.is_action_pressed("spin_right"):
		#planet.global_rotate(Vector3.UP, speed * delta)
	if Input.is_action_pressed("left"):
		guts.angular_velocity = Vector3(0.0, 0.0, -100.0*delta)
	if Input.is_action_pressed("right"):
		guts.angular_velocity = Vector3(0.0, 0.0, 100.0*delta)
	#if Input.is_action_pressed("up"):
		#planet.global_rotate(Vector3.LEFT, -speed * delta)
	#if Input.is_action_pressed("down"):
		#planet.global_rotate(Vector3.LEFT, speed * delta)
	
	
	
	#old for reference
	
	#if Input.is_action_pressed("spin_left"):
		#planet.global_rotate(Vector3.UP, -speed * delta)
	#if Input.is_action_pressed("spin_right"):
		#planet.global_rotate(Vector3.UP, speed * delta)
	#if Input.is_action_pressed("left"):
		#planet.global_rotate(Vector3.FORWARD, speed * delta)
	#if Input.is_action_pressed("right"):
		#planet.global_rotate(Vector3.FORWARD, -speed * delta)
	#if Input.is_action_pressed("up"):
		#planet.global_rotate(Vector3.LEFT, -speed * delta)
	#if Input.is_action_pressed("down"):
		#planet.global_rotate(Vector3.LEFT, speed * delta)
