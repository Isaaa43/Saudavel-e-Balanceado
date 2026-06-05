class_name StaticBodyArmadilha
extends StaticBody3D

@onready var mesh_instance_3d: MeshInstance3D = $"../MeshInstance3D"

func _ready() -> void:
	await get_tree().process_frame
	_material_outline = mesh_instance_3d.material_overlay
	toggle_shader_revelacao(false)

var _material_outline: ShaderMaterial

func toggle_shader_revelacao(ligado: bool) -> void:
	if ligado:
		mesh_instance_3d.material_overlay = _material_outline
	else:
		mesh_instance_3d.material_overlay = null
