class_name GameAdm
extends Node

signal game_loaded

@export var jogadores_adm : JogadoresAdm
@export var local_adm : LocalAdm
@export var timer_adm: TimerAdm
@export var estado_partida_adm: EstadoPartidaAdm

@export var efeito_fim_tempo: FeiticoEfeitoDef

@export_group("Audios Partida")
@export var audio_stream_player_partida: AudioStreamPlayer
@export var som_comeco_partida: AudioStream
@export var som_fim_partida: AudioStream

func _ready() -> void:
	# ajustar sinais
	_conectar_sinais()
	game_loaded.emit()
	
	if TrocaCenaTemp.is_treino:
		_modo_treino()
	
	# Inicia a partida
	estado_partida_adm.set_rolando()
	
	if multiplayer.is_server():
		SaveData.iniciar_partida()
		# salva os decks dos jogadores
		Network.server.salvar_decks()
		

func _conectar_sinais() -> void:
	# jogadores
	jogadores_adm.recebido_jogador_authority.connect(local_adm.ajusta_para_jogador)
	jogadores_adm.recebido_jogador_outros.connect(local_adm.outro_jogador)
	jogadores_adm.recebido_dados_jog_authority.connect(local_adm.ajusta_dados_jogador)
	# timer
	timer_adm.tempo_atualizado.connect(local_adm.ajusta_tempo_partida)
	timer_adm.tempo_minuto_final.connect(local_adm.tempo_minuto_final)
	timer_adm.tempo_esgotado.connect(fim_tempo)
	timer_adm.tempo_esgotado.connect(local_adm.tempo_final)
	# estado da partida
	estado_partida_adm.estado_atualizado.connect(_atualizar_estado_partida)
	# 
	local_adm.pediu_sair_partida.connect(_pedir_sair_partida)
	# rede
	Network.client.morreu_jogador.connect(_matar_jogador)
	Network.client.morreu_jogador.connect(_marcar_ganhador)
	Network.client.ganhador_jogador.connect(_exibir_ganhador)
	

func fim_tempo() -> void:
	if not multiplayer.is_server(): return
	
	estado_partida_adm.set_fim_tempo()

func _pedir_sair_partida() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Network.client.pedir_terminar_partida()

# TODO: Alterar fora do debug
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug"):
		_pedir_sair_partida()

# Final de Jogo
# -----------------------------------------------------------------------------

# TODO: verificar se essa eh a melhor maneira
func _matar_jogador(peer_id_jog: int) -> void:
	var jog_morto: Jogador = jogadores_adm.get_jogador_peer_id(peer_id_jog)
	
	if multiplayer.is_server():
		SaveData.registrar_morte(peer_id_jog, jog_morto.jogador_corpo.global_position)
	
	# transforma o jog em fantasma
	jogadores_adm.matar_jogador(peer_id_jog)
	# para as funcionalidades locais do jog (castar feiticos)
	local_adm.matar_jogador(jog_morto)

func _marcar_ganhador(peer_id_jog_morto: int) -> void:
	if not multiplayer.is_server(): return
	
	# pega o peer_id do ganhador
	var peer_id_ganhador : int = -1 
	var jogadores_por_peer_id: Dictionary[int, Jogador] = jogadores_adm.get_jogadores_por_peer_id()
	for peer_id: int in jogadores_por_peer_id.keys():
		if peer_id != peer_id_jog_morto:
			peer_id_ganhador = peer_id
			break
	# emite o ganhador
	Network.server.anunciar_ganhador(peer_id_ganhador)
	
	# ajusta estado da partida para fim
	estado_partida_adm.set_fim_partida()

func _exibir_ganhador(peer_id_ganhador: int) -> void:
	# espera um pouco
	await get_tree().create_timer(2.5).timeout
	# pega o jogador ganhador
	var jog_ganhador: Jogador = jogadores_adm.get_jogador_peer_id(peer_id_ganhador)
	# exibe a tela de fim com o nome do jogador ganhador
	local_adm.tela_fim(jog_ganhador)

# Audios da partida
# -----------------------------------------------------------------------------

func _tocar_audio_comeco_partida() -> void:
	audio_stream_player_partida.stream = som_comeco_partida
	audio_stream_player_partida.play()

func _tocar_audio_fim_partida() -> void:
	audio_stream_player_partida.stream = som_fim_partida
	audio_stream_player_partida.play()

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
	# iniciar partida
	timer_adm.iniciar()
	# tocar som de inicio
	_tocar_audio_comeco_partida()

func _fim_tempo() -> void:
	aplicar_dano_jogadores()

func _fim_partida() -> void:
	# para o timer
	timer_adm.parar()
	# toca o som de fim de partida
	_tocar_audio_fim_partida()

# ---------
func aplicar_dano_jogadores() -> void:
	jogadores_adm.dimiuir_vida_jogadores(efeito_fim_tempo)
	local_adm.bloquear_cura()


# Modo Treino ---------

const TREINO_EFEITO_VIDA_REGEN = preload("uid://brvm73b1lyaio")

func _modo_treino() -> void:
	# cria um jogador novo
	var dados_jog_treino := DadosJogador.new()
	dados_jog_treino.peer_id = -99
	dados_jog_treino.nome = "Alvo"
	jogadores_adm._server_spawnar_jogador(dados_jog_treino)
	# pega o jogador criado
	var jog_treino: Jogador = jogadores_adm.jogadores_por_peer_id[dados_jog_treino.peer_id]
	# coloca no meio do mapa
	jog_treino.global_position_inicial = Vector3.ZERO
	# mostra o dano levado
	jog_treino.sistema_vida.levou_dano.connect(jog_treino.jogador_corpo.mostrar_levar_dano_numeros)
	# adiciona um efeito de regen de vida
	var efeito_vida_regen : FeiticoEfeito = TREINO_EFEITO_VIDA_REGEN.criar()
	jog_treino.receptor_efeitos.receber_efeito(efeito_vida_regen)
	# adiciona sistema de movimento de treino
	jog_treino.sistema_movimento = SistemaMovimentoTreino.new()
	jog_treino.sistema_movimento.jogador = jog_treino.corpo
	jog_treino.add_child(jog_treino.sistema_movimento)
