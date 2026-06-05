class_name Jogador
extends Entidade

@export var sistema_vida : SistemaVida
@export var sistema_mana : SistemaMana

@export var fantasma_ref: PackedScene
var fantasma: Node3D

@onready var sistema_movimento: SistemaMovimento = $SistemaMovimento

@onready var camera_jogador: CameraJogador = $CameraJogador

var jogador_corpo : JogadorCorpo

var dados_jogador : DadosJogador :
	set(_dados_jog):
		dados_jogador = _dados_jog
		call_deferred("_display_nome")

func _turn_off(node : Node) -> void:
	node.set_process(false)
	node.set_physics_process(false)
	node.set_process_input(false)
	node.set_process_unhandled_input(false)
	#node.process_mode = Node.PROCESS_MODE_DISABLED

func _enter_tree() -> void:
	set_multiplayer_authority(str(name).to_int())

func _ready() -> void:
	super()
	
	jogador_corpo = corpo
	sistema_vida.levou_dano.connect(jogador_corpo.mostrar_levar_dano)
	fantasma = fantasma_ref.instantiate()
	
	# se nao for este computador controlando esse nodo, desligue esse nodo
	if not is_multiplayer_authority():
		_turn_off(self)
		_turn_off(jogador_corpo)
		camera_jogador.queue_free()
		sistema_movimento.queue_free()
		jogador_corpo.set_physics_process(true) ##
		jogador_corpo.sphere_visao_limitada.queue_free()
		return
	
	_ready_camera()
	# conectar os sinais
	sistema_vida.morreu.connect(morrer)

func _ready_camera() -> void:
	camera_jogador.start()
	# linka a cabeca com a camera
	jogador_corpo.conectar_camera(camera_jogador)
	# 
	jogador_corpo.esconder_mesh()

# TODO: arrumar
func _display_nome() -> void:
	jogador_corpo._display_nome(dados_jogador)

# -----------------------------------------------------------------------------
# Movimentacao
# -----------------------------------------------------------------------------

func spawnar(global_pos: Vector3) -> void:
	jogador_corpo.global_position = global_pos
	jogador_corpo.velocity = Vector3.ZERO

# -----------------------------------------------------------------------------
# Sistema Vida
# -----------------------------------------------------------------------------

func morrer() -> void:
	Network.client.avisar_jogador_morreu()
	_virar_fantasma()

## Local desse jogador
func _virar_fantasma() -> void:
	camera_jogador.corpo_rotacao = fantasma
	sistema_movimento.process_mode = Node.PROCESS_MODE_DISABLED

## Troca o visual do corpo por fantasma
func virar_fantasma() -> void:
	add_child(fantasma)
	fantasma.transform = jogador_corpo.transform
	#
	jogador_corpo.hide()
	jogador_corpo.process_mode = Node.PROCESS_MODE_DISABLED
	remove_child(jogador_corpo)
