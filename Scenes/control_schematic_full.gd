extends Control
@onready var timer: Timer = $Timer

@onready var mouse_image: TextureRect = $MouseImage
@onready var key_f: TextureRect = $KeyF
@onready var tab: TextureRect = $Tab
@onready var key_1: TextureRect = $Key1
@onready var key_2: TextureRect = $Key2
@onready var key_3: TextureRect = $Key3
@onready var key_4: TextureRect = $Key4
@onready var esc: TextureRect = $Esc
@onready var space: TextureRect = $Space
@onready var pause: Label = $pause
@onready var map: Label = $map
@onready var move: Label = $move
@onready var interact: Label = $interact
@onready var honk: Label = $honk
@onready var look: Label = $look

var mouse_image_position: Vector2
var key_f_position: Vector2
var tab_position: Vector2
var key_1_position: Vector2
var key_2_position: Vector2
var key_3_position: Vector2
var key_4_position: Vector2
var esc_position: Vector2
var space_position: Vector2
var pause_position: Vector2
var map_position: Vector2
var move_position: Vector2
var interact_position: Vector2
var honk_position: Vector2
var look_position: Vector2

var flag : bool = false

func _ready() -> void:
		
	mouse_image_position = mouse_image.position
	key_f_position = key_f.position
	tab_position = tab.position
	key_1_position = key_1.position
	key_2_position = key_2.position
	key_3_position = key_3.position
	key_4_position = key_4.position
	esc_position = esc.position
	space_position = space.position
	pause_position = pause.position
	map_position = map.position
	move_position = move.position
	interact_position = interact.position
	honk_position = honk.position
	look_position = look.position

func shift():
	if not flag:
		mouse_image.position = Vector2(mouse_image.position.x + randf_range(-2.0,2.0), mouse_image.position.y + randf_range(-2.0,2.0))
		key_f.position = Vector2(key_f.position.x + randf_range(-2.0,2.0), key_f.position.y + randf_range(-2.0,2.0))
		tab.position = Vector2(tab.position.x + randf_range(-2.0,2.0), tab.position.y + randf_range(-2.0,2.0))
		key_1.position = Vector2(key_1.position.x + randf_range(-2.0,2.0), key_1.position.y + randf_range(-2.0,2.0))
		key_2.position = Vector2(key_2.position.x + randf_range(-2.0,2.0), key_2.position.y + randf_range(-2.0,2.0))
		key_3.position = Vector2(key_3.position.x + randf_range(-2.0,2.0), key_3.position.y + randf_range(-2.0,2.0))
		key_4.position = Vector2(key_4.position.x + randf_range(-2.0,2.0), key_4.position.y + randf_range(-2.0,2.0))
		esc.position = Vector2(esc.position.x + randf_range(-2.0,2.0), esc.position.y + randf_range(-2.0,2.0))
		space.position = Vector2(space.position.x + randf_range(-2.0,2.0), space.position.y + randf_range(-2.0,2.0))
		pause.position = Vector2(pause.position.x + randf_range(-2.0,2.0), pause.position.y + randf_range(-2.0,2.0))
		map.position = Vector2(map.position.x + randf_range(-2.0,2.0), map.position.y + randf_range(-2.0,2.0))
		move.position = Vector2(move.position.x + randf_range(-2.0,2.0), move.position.y + randf_range(-2.0,2.0))
		interact.position = Vector2(interact.position.x + randf_range(-2.0,2.0), interact.position.y + randf_range(-2.0,2.0))
		honk.position = Vector2(honk.position.x + randf_range(-2.0,2.0), honk.position.y + randf_range(-2.0,2.0))
		look.position = Vector2(look.position.x + randf_range(-2.0,2.0), look.position.y + randf_range(-2.0,2.0))
		flag = true
	else:
		mouse_image.position = mouse_image_position
		key_f.position = key_f_position
		tab.position = tab_position
		key_1.position = key_1_position
		key_2.position = key_2_position
		key_3.position = key_3_position
		key_4.position = key_4_position
		esc.position = esc_position
		space.position = space_position
		pause.position = pause_position
		map.position = map_position
		move.position = move_position
		interact.position = interact_position
		honk.position = honk_position
		look.position = look_position
		flag = false
