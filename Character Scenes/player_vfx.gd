extends Node3D


@onready var walk_poof_particles: GPUParticles3D = $WalkPoofParticles

@export var local_space : bool = false

var feet_particles_left_pos : Vector3 = Vector3(-.1, .008, 0.0)
var feet_particles_right_pos : Vector3 = Vector3(.1, .008, 0.0)
var foot_flag : bool = true


func reset_foot_flag() -> void:
	foot_flag = true


func walk_particles() -> void:
	var new_particle = walk_poof_particles.duplicate()
	add_child(new_particle)
	new_particle.local_coords = local_space
	if not foot_flag:
		new_particle.position = feet_particles_left_pos
		foot_flag = true
	else:
		new_particle.position = feet_particles_right_pos
		foot_flag = false
	new_particle.restart()
