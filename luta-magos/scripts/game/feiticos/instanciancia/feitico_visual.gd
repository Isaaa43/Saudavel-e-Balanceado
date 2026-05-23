class_name FeiticoVisual
extends Node

var visual_3d: Node3D :
	set(_visual_3d):
		visual_3d = _visual_3d
		_ajustar_particulas()

var particulas: GPUParticles3D

func _ajustar_particulas() -> void:
	for child : Node in visual_3d.get_children():
		if child is GPUParticles3D:
			particulas = child


#var is_corpo_animado: bool = false

#var anim_colisao
