class_name MeshCorpo
extends Node3D

# -- Cabeca --

@onready var cabeca_pivot: Node3D = $Cabeca/CabecaPivot
@onready var skeleton_3d: Skeleton3D = $Rig_Sapo/Armature/Skeleton3D

var camera : Camera3D :
	set(_cam):
		camera = _cam
		set_process(true)
		set_physics_process(true)

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
	
	set_process(false)
	set_physics_process(false)


func _process(delta: float) -> void:
	_process_camera(delta)

func esconder_mesh() -> void:
	mesh_instance_3d.hide()


# Shaders
# -----------------------------------------------------------------------------

enum ShadersTipo {NENHUM, REVELADO, CONGELADO}
var curr_shader := ShadersTipo.NENHUM

func shader_revelacao(duracao_seg: float) -> void:
	mudar_shader(ShadersTipo.REVELADO)
	_marcar_desligar(duracao_seg)

func shader_congelado(duracao_seg: float) -> void:
	mudar_shader(ShadersTipo.CONGELADO)
	_marcar_desligar(duracao_seg)

var deligar_shader_time_ms : int = 1
func _marcar_desligar(duracao_seg: float) -> void:
	# salva o tempo que deve ser desligado o shader
	@warning_ignore("narrowing_conversion")
	deligar_shader_time_ms = Time.get_ticks_msec() + (duracao_seg * 1000)
	# cria um timer para chamar a funcao de desligar
	get_tree().create_timer(duracao_seg).timeout.connect(_desligar_shader)

func _desligar_shader() -> void:
	# se o deligar_shader_time_ms for maior entao quer dizer 
	#	que outro shader foi aplicado depois, e deve ser desligado mais tarde
	#	(-100 para caso o timer nao seja perfeito, 0.1s serve como margem de erro)
	if Time.get_ticks_msec() >= deligar_shader_time_ms - 100:
		mudar_shader(ShadersTipo.NENHUM)

func mudar_shader(tipo: ShadersTipo) -> void:
	# se estiver zerando, tem a preferencia
	if tipo == ShadersTipo.NENHUM:
		_aplicar_shader(ShadersTipo.NENHUM)
		return
	# se estiver revelado, nao aplique outro em cima
	if curr_shader == ShadersTipo.REVELADO:
		return
	# se for outro tipo, mude para esse novo
	_aplicar_shader(tipo)

func _aplicar_shader(tipo: ShadersTipo) -> void:
	match (tipo):
		ShadersTipo.NENHUM:
			mesh_instance_3d.material_overlay = null
		ShadersTipo.REVELADO:
			mesh_instance_3d.material_overlay = REVELADO_MAT
		ShadersTipo.CONGELADO:
			mesh_instance_3d.material_overlay = CONGELADO_MAT
	curr_shader = tipo

# Cabeca
# -----------------------------------------------------------------------------
func _process_camera(_delta: float) -> void:
	# rodar a cabeca
	cabeca_rot = remap(camera.rotation.x, -PI/2, PI/2, -PI/6, PI/6)
	## hack para rotacionar o bone de cabeca
	#cabeca_pivot.rotation.x = cabeca_rot 
	cabeca_pivot.rotation.z = -cabeca_rot 

func _physics_process(_delta: float) -> void:
	# Get the current bone rotation
	var current_rot = skeleton_3d.get_bone_pose_rotation(bone_head_idx)

	# Convert cabeca_pivot's rotation to quaternion and combine with base rotation
	var pivot_rot = cabeca_pivot.quaternion
	var target_rot = bone_head_base_rot * pivot_rot  # Apply base rotation first, then pivot

	# Smoothly rotate towards it
	var new_rot = current_rot.slerp(target_rot, 0.1)
	skeleton_3d.set_bone_pose_rotation(bone_head_idx, new_rot)
