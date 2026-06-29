class_name MeshCorpo
extends Node3D

# -- Cabeca --

@onready var cabeca_pivot: Node3D = $Cabeca/CabecaPivot
@onready var skeleton_3d: Skeleton3D = $Rig_Sapo/Armature/Skeleton3D

var camera : Camera3D :
	set(_cam):
		camera = _cam

var cabeca_rot: float = 0.0

var bone_head_idx: int
var bone_head_base_rot : Quaternion

# -- Shaders --

@onready var frogger_skinned: MeshInstance3D = $Rig_Sapo/Armature/Skeleton3D/Frogger_Skinned

var _material_outline: ShaderMaterial
var mesh_instance_3d: MeshInstance3D

const REVELADO_MAT = preload("uid://c25lrwh5o1e6r")
const CONGELADO_MAT = preload("uid://cpsyvawnev4gg")


func _ready() -> void:
	bone_head_idx = skeleton_3d.find_bone("Head")
	bone_head_base_rot = skeleton_3d.get_bone_pose_rotation(bone_head_idx)
	
	mesh_instance_3d = frogger_skinned
	_material_outline = mesh_instance_3d.material_overlay


func _physics_process(delta: float) -> void:
	_process_shader(delta)
	if camera:
		# se for o jogador local, envia a posicao do pivot da cabeca 
		_process_my_head_with_camera(delta)
	else:
		# se for o jogador online, rotacione a cabeca para ser igual ao pivot
		_process_network_head(delta)

func esconder_mesh() -> void:
	mesh_instance_3d.hide()


# Shaders
# -----------------------------------------------------------------------------

enum ShadersTipo {NENHUM, REVELADO, CONGELADO}
var curr_shader := ShadersTipo.NENHUM

var duracao_shader_seg : Dictionary[ShadersTipo, float] = {}

func shader_revelacao(duracao_seg: float) -> void:
	mudar_shader(ShadersTipo.REVELADO)
	duracao_shader_seg[ShadersTipo.REVELADO] = duracao_seg

func shader_congelado(duracao_seg: float) -> void:
	mudar_shader(ShadersTipo.CONGELADO)
	duracao_shader_seg[ShadersTipo.CONGELADO] = duracao_seg

func mudar_shader(tipo: ShadersTipo) -> void:
	match (tipo):
		ShadersTipo.NENHUM:
			mesh_instance_3d.material_overlay = null
		ShadersTipo.REVELADO:
			mesh_instance_3d.material_overlay = REVELADO_MAT
			_set_visivel(true)
		ShadersTipo.CONGELADO:
			mesh_instance_3d.material_overlay = CONGELADO_MAT
	curr_shader = tipo

func _desligar_shader(shader_tipo: ShadersTipo) -> void:
	duracao_shader_seg.erase(shader_tipo)
	# se nao tiver nenhum outro shader aplicado, apenas tire o shader
	if duracao_shader_seg.is_empty():
		mudar_shader(ShadersTipo.NENHUM)
	# se tiver outro shader, mas o que foi desligado era o que estava sendo exibido
	elif curr_shader == shader_tipo:
		# troque para o outro shader
		mudar_shader(duracao_shader_seg.keys()[0])
	# se tiver outro shader, e o desligado nem estava sendo exibido, nao mude nada

func _process_shader(delta) -> void:
	# passa por todos os shaders ligados
	for shader_tipo: ShadersTipo in duracao_shader_seg.keys():
		duracao_shader_seg[shader_tipo] -= delta
		# se tiver algum shader para desligar
		if duracao_shader_seg[shader_tipo] <= 0.0:
			_desligar_shader(shader_tipo)

# Cabeca
# -----------------------------------------------------------------------------
func _process_my_head_with_camera(_delta: float) -> void:
	# pega a rotacao da cabeca e diminui (para nao olhar 90 graus para cima)
	cabeca_rot = remap(camera.rotation.x, -PI/2, PI/2, -PI/6, PI/6)
	# rotaciono o pivo da cabeca, para enviar pelo network
	#cabeca_pivot.rotation.x = cabeca_rot 
	cabeca_pivot.rotation.z = -cabeca_rot 

func _process_network_head(_delta: float) -> void:
	# transforma a rotacao do pivot em quartenion
	var pivot_rot := cabeca_pivot.quaternion
	# combina a rotacao do pivot com a base da cabeca 
	# para chegar na rotacao que a gente quer que o bone da cabeca esteja
	var target_rot := bone_head_base_rot * pivot_rot  # Apply base rotation first, then pivot

	# pega a rotacao atual da cabeca
	var current_rot := skeleton_3d.get_bone_pose_rotation(bone_head_idx)
	# faz o slerp para deixar mais smooth
	var smooth_rot := current_rot.slerp(target_rot, _delta)
	
	# rotaciona o bone da cabeca
	skeleton_3d.set_bone_pose_rotation(bone_head_idx, smooth_rot)

# Outro jogador visivel 
# -----------------------------------------------------------------------------

## Chamado para dizer se o jogador (online) esta em uma distancia visivel do jogador (PC)
func visivel_distancia(visivel: bool) -> void:
	if curr_shader == ShadersTipo.REVELADO:
		_set_visivel(true)
		return
	
	_set_visivel(visivel)

## Muda a visibilidade do jogador (online) para no jogador (PC)
func _set_visivel(visivel: bool) -> void:
	visible = visivel
