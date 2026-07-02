class_name GameAdm
extends Node

signal game_loaded

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
	
	game_loaded.emit()
	if TrocaCenaTemp.is_treino:
		_modo_treino()
	
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
	var jog_morto: Jogador = jogadores_adm.get_jogador_peer_id(peer_id_jog)
	
	if multiplayer.is_server():
		SaveData.registrar_morte(peer_id_jog, jog_morto.jogador_corpo.global_position)
	
	# transforma o jog em fantasma
	jogadores_adm.matar_jogador(peer_id_jog)
	# para as funcionalidades locais do jog (castar feiticos)
	local_adm.matar_jogador(jog_morto)
	
	estado_partida_adm.set_fim_partida()

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
	# para o timer
	timer_adm.parar()
	
	# exibe a tela de fim com o nome do jogador ganhador
	var jog_ganhador: Jogador = jogadores_adm.get_jogadores_vivos()[0]
	#for jog: Jogador in jogadores_adm.jogadores_por_peer_id.values():
		#if jog != jog_morto:
			#jog_ganhador = jog
			#break
	await get_tree().create_timer(2.5).timeout
	local_adm.tela_fim(jog_ganhador)


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
