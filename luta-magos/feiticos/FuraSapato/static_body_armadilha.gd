class_name StaticBodyArmadilha
extends StaticBody3D

@export var entidade: EntidadeFeitico

const REVELADO_MAT = preload("uid://c25lrwh5o1e6r")

@export var mesh_instance_3d: MeshInstance3D

@export var tempo_inicio_ate_invisivel: float = 1.5

@export var transparencia_escondido_criador := 0.93
@export var transparencia_revelado_criado := 0.8

var _material_revelado: Material

func _ready() -> void:
	await get_tree().process_frame
	toggle_shader_revelacao(false)
	_material_revelado = REVELADO_MAT
	# deixa invisivel depois de um tempo inicial
	get_tree().create_timer(tempo_inicio_ate_invisivel).timeout.connect(deixar_invisivel)

func deixar_invisivel() -> void:
	if Registros.jogador_id_local == entidade.criador_id:
		mesh_instance_3d.show()
		# se for o criador fica transparencia_escondido_criador
		mesh_instance_3d.transparency = transparencia_escondido_criador
	else:
		# se nao for o criador fica invisivel
		mesh_instance_3d.hide()

func deixar_visivel() -> void:
	mesh_instance_3d.show()
	if Registros.jogador_id_local == entidade.criador_id:
		# se for o criador fica rencia_revelado_criado
		mesh_instance_3d.transparency = transparencia_revelado_criado
	else:
		# se nao for o criador fica completamente visivel
		mesh_instance_3d.transparency = 0.0 # opaco

func toggle_shader_revelacao(ligado: bool) -> void:
	if ligado:
		mesh_instance_3d.material_overlay = _material_revelado
		deixar_visivel()
	else:
		mesh_instance_3d.material_overlay = null
