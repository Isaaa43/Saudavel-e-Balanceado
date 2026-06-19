extends Node3D
class_name FeiticoVisualRevelacao

@export var csg_sphere_3d: CSGSphere3D
@export var gpu_particles_aura: GPUParticles3D
@export var gpu_particles_particulas: GPUParticles3D

func resize(raio: float) -> void:
	# mesh
	csg_sphere_3d.radius = raio
	# aura
	var mesh: Mesh = gpu_particles_aura.draw_pass_1
	mesh.size = Vector2(raio*2, raio*2) # diametro
	# particulas
	var proc_mat: ParticleProcessMaterial = gpu_particles_particulas.process_material
	proc_mat.emission_sphere_radius = raio
