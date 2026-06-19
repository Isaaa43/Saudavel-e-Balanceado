class_name StaticBodyArmadilha
extends StaticBody3D

const REVELDO_MAT = preload("uid://c25lrwh5o1e6r")

@export var mesh_instance_3d: MeshInstance3D

var _material_revelado: Material

func _ready() -> void:
	await get_tree().process_frame
	toggle_shader_revelacao(false)
	_material_revelado = REVELDO_MAT

func toggle_shader_revelacao(ligado: bool) -> void:
	if ligado:
		mesh_instance_3d.material_overlay = _material_revelado
	else:
		mesh_instance_3d.material_overlay = null
