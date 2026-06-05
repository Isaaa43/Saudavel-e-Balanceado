class_name JogadorCorpo
extends CharacterBody3D

var camera_jogador: CameraJogador

@onready var sistema_animacao: SistemaAnimacao = $SistemaAnimacao

@onready var cabeca_pivot: Node3D = $Corpo/Cabeca/CabecaPivot
@onready var remote_transform_cabeca: RemoteTransform3D = $Corpo/Cabeca/RemoteTransformCabeca
@onready var mesh_corpo: MeshInstance3D = $Corpo/MeshCorpo
@onready var frogger_skinned: MeshInstance3D = $Corpo/Rig_Sapo/Armature/Skeleton3D/Frogger_Skinned
@onready var skeleton_3d: Skeleton3D = $Corpo/Rig_Sapo/Armature/Skeleton3D
@onready var rig_sapo: Node3D = $Corpo/Rig_Sapo

var bone_head_idx: int
var bone_head_base_rot : Quaternion

@onready var audio_player_dano: AudioStreamPlayer3D = $AudioPlayerDano
@onready var label_dano: Label3D = $LabelDano

func _ready() -> void:
	mesh_instance_3d = frogger_skinned
	_material_outline = mesh_instance_3d.material_overlay
	toggle_shader_revelacao(false)
	
	bone_head_idx = skeleton_3d.find_bone("Head")
	bone_head_base_rot = skeleton_3d.get_bone_pose_rotation(bone_head_idx)

var _material_outline: ShaderMaterial
var mesh_instance_3d: MeshInstance3D

func toggle_shader_revelacao(ligado: bool) -> void:
	if ligado:
		mesh_instance_3d.material_overlay = _material_outline
	else:
		mesh_instance_3d.material_overlay = null


func esconder_mesh() -> void:
	mesh_instance_3d.hide()
	rig_sapo.hide()

func _process(delta: float) -> void:
	_process_camera(delta)


func _process_camera(_delta: float) -> void:
	var camera : Camera3D = camera_jogador.camera
	# rodar a cabeca
	var cabeca_rot = remap(camera.rotation.x, -PI/2, PI/2, -PI/3, PI/3)
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


func conectar_camera(_camera_jogador: CameraJogador) -> void:
	camera_jogador = _camera_jogador
	#
	remote_transform_cabeca.remote_path = camera_jogador.get_path()
	remote_transform_cabeca.force_update_cache()

func mostrar_levar_dano(dano: float) -> void:
	audio_player_dano.play()
	# TODO: remover
	# mostra o dano em cima do jog
	#label_dano.text = "Dano:\n%d" % dano
	#label_dano.show()
	#get_tree().create_timer(1.2).timeout.connect( func(): label_dano.hide() )

# TODO: arrumar
@onready var label_nome: Label3D = $LabelNome
func _display_nome(dados_jogador) -> void:
	if not (dados_jogador and is_instance_valid(dados_jogador)): return
	if not (label_nome and is_instance_valid(label_nome)): return
	
	#var nome : String = dados_jogador.nome
	#if dados_jogador.nome and dados_jogador.nome != "" and (not dados_jogador.nome.is_empty()):
		#label_nome.text = nome
