extends Node3D

enum {IDLE, WALK, JUMP, GET, GIVE, TALK, VICTORY}
@onready var main_scene: Node3D = $"."
@onready var player_character: CharacterBody3D = $PlayerCharacter
