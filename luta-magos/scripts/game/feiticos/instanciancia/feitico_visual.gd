class_name FeiticoVisual
extends Node

var visual_3d: Node3D :
	set(_visual_3d):
		visual_3d = _visual_3d
		iniciar()

func iniciar() -> void:
	_ajustar_particulas()
	for child : Node in visual_3d.get_children():
		if child is MeshInstance3D:
			mesh_instance_3d = child
			_material_outline = mesh_instance_3d.material_overlay
			break
	

var particulas: GPUParticles3D

func _ajustar_particulas() -> void:
	for child : Node in visual_3d.get_children():
		if child is GPUParticles3D:
			particulas = child


var _material_outline: ShaderMaterial
var mesh_instance_3d: MeshInstance3D

func toggle_shader_revelacao(ligado: bool) -> void:
	if ligado:
		mesh_instance_3d.material_overlay = _material_outline
	else:
		mesh_instance_3d.material_overlay = null
	

#var is_corpo_animado: bool = false

#var anim_colisao
