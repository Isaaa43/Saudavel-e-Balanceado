class_name FeiticoVisualBolaFogo
extends Node3D

@export var fogo: GPUParticles3D
@export var csg_sphere_3d: CSGSphere3D
@export var csg_sphere_3d_flip: CSGSphere3D

var resized : bool = false

func _ready() -> void:
	fogo.hide()
	await get_tree().create_timer(0.3).timeout
	# TODO: melhorar
	if resized:
		csg_sphere_3d_flip.hide()
	else:
		# se nao foi alterado o tamanho, (ou seja eh a bola de fogo normal)
		# mostra o trail novamente
		fogo.show()

func resize(raio: float) -> void:
	resized = (raio >= 1)
	# mesh
	csg_sphere_3d.radius = raio
	csg_sphere_3d_flip.radius = raio
	# trail
	#var mesh: Mesh = fogo.draw_pass_1
	#mesh.size = Vector2(raio*2, raio*2) # diametro
