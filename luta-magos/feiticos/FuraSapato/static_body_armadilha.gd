class_name StaticBodyArmadilha
extends StaticBody3D

const REVELDO_MAT = preload("uid://c25lrwh5o1e6r")

@export var mesh_instance_3d: MeshInstance3D

@export var tempo_inicio_ate_invisivel: float = 1.5

var _material_revelado: Material

func _ready() -> void:
	await get_tree().process_frame
	toggle_shader_revelacao(false)
	_material_revelado = REVELDO_MAT
	# deixa invisivel depois de um tempo inicial
	get_tree().create_timer(tempo_inicio_ate_invisivel).timeout.connect(deixar_invisivel)

func deixar_invisivel() -> void:
	mesh_instance_3d.hide()
func deixar_visivel() -> void:
	mesh_instance_3d.show()

func toggle_shader_revelacao(ligado: bool) -> void:
	if ligado:
		mesh_instance_3d.material_overlay = _material_revelado
		deixar_visivel()
	else:
		mesh_instance_3d.material_overlay = null
