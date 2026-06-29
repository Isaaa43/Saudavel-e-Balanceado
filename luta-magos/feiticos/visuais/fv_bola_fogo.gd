class_name FeiticoVisualBolaFogo
extends Node3D

@export var fogo: GPUParticles3D
@export var csg_sphere_3d: CSGSphere3D
@export var csg_sphere_3d_flip: CSGSphere3D

func _ready() -> void:
	fogo.hide()
	await get_tree().create_timer(0.3).timeout
	fogo.show()
	csg_sphere_3d_flip.hide()

func resize(raio: float) -> void:
	# mesh
	csg_sphere_3d.radius = raio
	csg_sphere_3d_flip.radius = raio
	# trail
	#var mesh: Mesh = fogo.draw_pass_1
	#mesh.size = Vector2(raio*2, raio*2) # diametro
