extends Node3D

@export var gpu_particles_lentas: GPUParticles3D
@export var gpu_particles_rapidas: GPUParticles3D


func _ready() -> void:
	gpu_particles_lentas.emitting = true
	gpu_particles_rapidas.emitting = true
