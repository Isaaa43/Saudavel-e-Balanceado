class_name Jogador
extends Entidade

@export var sistema_vida : SistemaVida
@export var sistema_mana : SistemaMana

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
	
	# se nao for este computador controlando esse nodo, desligue esse nodo
	if not is_multiplayer_authority():
		_turn_off(self)
		_turn_off(jogador_corpo)
		camera_jogador.queue_free()
		sistema_movimento.queue_free()
		return
	
	_ready_camera()
	# conectar os sinais
	sistema_vida.morreu.connect(morrer)

func _ready_camera() -> void:
	camera_jogador.start()
	# linka a cabeca com a camera
	jogador_corpo.conectar_camera(camera_jogador)

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
	await get_tree().create_timer(0.5).timeout
	Network.client.pedir_terminar_partida()
