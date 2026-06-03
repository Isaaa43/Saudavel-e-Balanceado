class_name GameAdm
extends Node

@export var jogadores_adm : JogadoresAdm
@export var local_adm : LocalAdm
@export var timer_adm: TimerAdm
@export var estado_partida_adm: EstadoPartidaAdm

@export var efeito_fim_tempo: FeiticoEfeitoDef

func _ready() -> void:
	# ajustar sinais
	_conectar_sinais()
	#TODO: hmm lugar melhot
	timer_adm.iniciar()

func _conectar_sinais() -> void:
	# jogadores
	jogadores_adm.recebido_jogador_authority.connect(local_adm.ajusta_para_jogador)
	jogadores_adm.recebido_dados_jog_authority.connect(local_adm.ajusta_dados_jogador)
	# timer
	timer_adm.tempo_atualizado.connect(local_adm.ajusta_tempo_partida)
	timer_adm.tempo_esgotado.connect(fim_tempo)
	# estado da partida
	estado_partida_adm.estado_atualizado.connect(_atualizar_estado_partida)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Network.client.pedir_terminar_partida()

func fim_tempo() -> void:
	estado_partida_adm.set_fim_tempo()

# Estado da Partida
# -----------------------------------------------------------------------------
func _atualizar_estado_partida(estado_partida: EstadoPartidaAdm.EstadoPartida) -> void:
	match (estado_partida):
		EstadoPartidaAdm.EstadoPartida.NAO_INICIADA:
			_nao_iniciada()
		EstadoPartidaAdm.EstadoPartida.ROLANDO:
			_rolando()
		EstadoPartidaAdm.EstadoPartida.FIM_TEMPO:
			_fim_tempo()
		EstadoPartidaAdm.EstadoPartida.FIM_PARTIDA:
			_fim_partida()

func _nao_iniciada() -> void:
	pass

func _rolando() -> void:
	pass

func _fim_tempo() -> void:
	aplicar_dano_jogadores()

func _fim_partida() -> void:
	pass




# ---------
func aplicar_dano_jogadores() -> void:
	jogadores_adm.dimiuir_vida_jogadores(efeito_fim_tempo)
