class_name JogadorCorpo
extends CharacterBody3D

var camera_jogador: CameraJogador

@onready var sphere_visao_limitada: CSGCylinder3D = $CSGVisaoLimitada
@onready var sistema_animacao: SistemaAnimacao = $SistemaAnimacao

@onready var remote_transform_cabeca: RemoteTransform3D = $Corpo/Cabeca/RemoteTransformCabeca

@onready var mesh_corpo: MeshCorpo = $Corpo
@onready var rig_sapo: Node3D = $Corpo/Rig_Sapo

@onready var audio_player_dano: AudioStreamPlayer3D = $AudioPlayerDano
@onready var label_dano: Label3D = $LabelDano


func _ready() -> void:
	pai_id = int(get_parent().name)
	if multiplayer.is_server():
		SaveData.registrar_entidade(_gravar_posicao)

func _exit_tree() -> void:
	# remove quando o jogador sai da cena
	SaveData.desregistrar_entidade(_gravar_posicao)

var pai_id: int 
func _gravar_posicao() -> void:
	SaveData.registrar_posicao(pai_id, global_position, rotation.y, mesh_corpo.cabeca_rot)


func toggle_shader_revelacao(ligado: bool) -> void:
	mesh_corpo.shader_revelacao(ligado)

func toggle_shader_congelar(ligado: bool) -> void:
	mesh_corpo.shader_congelado(ligado)
	sistema_animacao.toggle_pausar(ligado)


func esconder_mesh() -> void:
	mesh_corpo.esconder_mesh()
	rig_sapo.hide()


func conectar_camera(_camera_jogador: CameraJogador) -> void:
	camera_jogador = _camera_jogador
	#
	mesh_corpo.camera = camera_jogador.camera
	#
	remote_transform_cabeca.remote_path = camera_jogador.get_path()
	remote_transform_cabeca.force_update_cache()

func mostrar_levar_dano(dano: float) -> void:
	audio_player_dano.play()


func mostrar_levar_dano_numeros(dano: float) -> void:
	# mostra o dano em cima do jog
	label_dano.text = "Dano:\n%d" % dano
	label_dano.show()
	get_tree().create_timer(1.5).timeout.connect( func(): label_dano.hide() )

# TODO: arrumar
@onready var label_nome: Label3D = $LabelNome
func _display_nome(dados_jogador) -> void:
	if not (dados_jogador and is_instance_valid(dados_jogador)): return
	if not (label_nome and is_instance_valid(label_nome)): return
	
	#var nome : String = dados_jogador.nome
	#if dados_jogador.nome and dados_jogador.nome != "" and (not dados_jogador.nome.is_empty()):
		#label_nome.text = nome
