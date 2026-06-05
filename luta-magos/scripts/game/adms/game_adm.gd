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
	
	if multiplayer.is_server():
		SaveData.iniciar_partida()

func _conectar_sinais() -> void:
	# jogadores
	jogadores_adm.recebido_jogador_authority.connect(local_adm.ajusta_para_jogador)
	jogadores_adm.recebido_dados_jog_authority.connect(local_adm.ajusta_dados_jogador)
	# timer
	timer_adm.tempo_atualizado.connect(local_adm.ajusta_tempo_partida)
	timer_adm.tempo_esgotado.connect(fim_tempo)
	# estado da partida
	estado_partida_adm.estado_atualizado.connect(_atualizar_estado_partida)
	# 
	local_adm.pediu_sair_partida.connect(_pedir_sair_partida)
	# 
	Network.client.morreu_jogador.connect(_matar_jogador)

func fim_tempo() -> void:
	estado_partida_adm.set_fim_tempo()

func _pedir_sair_partida() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Network.client.pedir_terminar_partida()

# TODO: Alterar fora do debug
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug"):
		_pedir_sair_partida()

# TODO: verificar se essa eh a melhor maneira
func _matar_jogador(peer_id_jog: int) -> void:

	
	# transforma o jog em fantasma
	jogadores_adm.matar_jogador(peer_id_jog)
	# para as funcionalidades locais do jog (castar feiticos)
	var jog_morto: Jogador = jogadores_adm.get_jogador_peer_id(peer_id_jog)
	local_adm.matar_jogador(jog_morto)
	# para o timer
	timer_adm.parar()
	
	if multiplayer.is_server():
		SaveData.registrar_morte(peer_id_jog, jog_morto.jogador_corpo.global_position)
	
	# exibe a tela de fim com o nome do jogador ganhador
	var jog_ganhador: Jogador
	for jog: Jogador in jogadores_adm.jogadores_por_peer_id.values():
		if jog != jog_morto:
			jog_ganhador = jog
			break
	await get_tree().create_timer(2.5).timeout
	local_adm.tela_fim(jog_ganhador)
	
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
