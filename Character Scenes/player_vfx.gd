extends Node3D

@onready var victory_confetti_particles: GPUParticles3D = $VictoryConfettiParticlesFalling
@onready var victory_confetti_still: GPUParticles3D = $VictoryConfettiStill
@onready var victory_smoke: GPUParticles3D = $VictorySmoke
@onready var gpu_particles_attractor_sphere_3d: GPUParticlesAttractorSphere3D = $GPUParticlesAttractorSphere3D
@onready var gpu_particles_collision_sphere_3d: GPUParticlesCollisionSphere3D = $GPUParticlesCollisionSphere3D


@onready var walk_poof_particles: GPUParticles3D = $WalkPoofParticles

@export var local_space : bool = false

var feet_particles_left_pos : Vector3 = Vector3(-.1, .008, 0.0)
var feet_particles_right_pos : Vector3 = Vector3(.1, .008, 0.0)
var jump_particle_location : Vector3 = Vector3(0.0, 1.846, -.082)
var foot_flag : bool = true
var player : CharacterBody3D
var main : Node3D
var grav_vector : Vector3


func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	main = get_tree().get_first_node_in_group("Main")


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
	await new_particle.finished
	new_particle.queue_free()


func victory_particles() -> void:
	grav_vector = player.grav_vector
	var new_particle = victory_confetti_particles.duplicate()
	var new_particle_2 = victory_smoke.duplicate()
	add_child(new_particle)
	add_child(new_particle_2)
	victory_confetti_still.seed = new_particle.seed
	victory_confetti_still.process_material.gravity = grav_vector
	new_particle.restart()
	new_particle_2.restart()
	await new_particle.finished
	new_particle.queue_free()


func jump_particles() -> void:
	grav_vector = player.grav_vector
	var new_particle = victory_confetti_particles.duplicate()
	var new_particle_2 = victory_smoke.duplicate()
	new_particle.position = jump_particle_location
	new_particle_2.position = jump_particle_location
	add_child(new_particle)
	add_child(new_particle_2)
	victory_confetti_still.seed = new_particle.seed
	victory_confetti_still.process_material.gravity = grav_vector
	new_particle.restart()
	new_particle_2.restart()
	await new_particle.finished
	new_particle.queue_free()


func collision_swap() -> void:
	if gpu_particles_collision_sphere_3d.visible:
		gpu_particles_collision_sphere_3d.visible = false
		
	else:
		gpu_particles_collision_sphere_3d.visible = true
