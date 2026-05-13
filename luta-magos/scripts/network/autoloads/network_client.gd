extends Node

signal ajustar_dados_jogador(jog_peer_id: int, dados_jog: DadosJogador)

@onready var dados_jogador : DadosJogador = criar_dados_jogador()

func _ready() -> void:
	_ready_lobby()
# -----------------------------------------------------------------------------
# Lobby
# -----------------------------------------------------------------------------

func _ready_lobby() -> void:
	Network.client_connection_ok.connect(_enviar_dados_jogador)
	
func entrar_lobby() -> void:
	Network.create_client()
	# atualiza os dados do jogador
	dados_jogador.peer_id = multiplayer.get_unique_id()
	
	# TODO: tela de conexao
	print("conectando ao servidor")

func _enviar_dados_jogador() -> void:	
	# Send to server
	NetworkServer.registrar_jogador.rpc_id(Network.SERVER_ID, dados_jogador.to_dict())
	
	TrocaCenaTemp.go_to_menu_partida()
	LogsAdm.add_conexao_texto("Entrou no lobby")

func criar_dados_jogador() -> DadosJogador:
	var dados := DadosJogador.new()
	dados.peer_id	= -1
	dados.nome 		= "Jogador"
	dados.grimorio 	= [1,2,3]
	dados.stats 	= {"level": 5, "xp": 1200}
	return dados

# -----------------------------------------------------------------------------
# Partida
# -----------------------------------------------------------------------------

signal spawnar_feitico(feitico_contexto : FeiticoContexto)

# TODO: trocar para load map, ou load game
@rpc("authority", "call_local", "reliable")
func iniciar_partida() -> void:
	TrocaCenaTemp.go_to_game()
	await get_tree().process_frame
	print("iniciar_partida id:", multiplayer.get_unique_id())

func pedir_terminar_partida() -> void:
	# Multiplayer offline
	if not Network.is_peer_connected():
		_terminar_partida()
	
	if multiplayer.is_server():
		NetworkServer.pedir_terminar_partida()
	else:
		NetworkServer.pedir_terminar_partida.rpc_id(Network.SERVER_ID)

## Cada peer termina sua partida
@rpc("authority", "call_local", "reliable")
func receber_terminar_partida() -> void:
	if multiplayer.is_server():
		# TODO: solucao melhor que essa do timer
		await get_tree().create_timer(0.2).timeout
	_terminar_partida()

func _terminar_partida() -> void:
	#TODO: Network.server_disconnected ?
	TrocaCenaTemp.go_to_menu_inicial()

func pedir_dados_jogador_do_jogador(jogador_peer_id: int) -> void:
	NetworkServer.get_dados_jogador_do_jogador.rpc_id(Network.SERVER_ID, jogador_peer_id)

@rpc("authority", "call_local", "reliable")
func receber_dados_jogador(jogador_peer_id: int, dados_jog_dict: Dictionary) -> void:
	var dados_jog := DadosJogador.from_dict(dados_jog_dict)
	ajustar_dados_jogador.emit(jogador_peer_id, dados_jog)

func lancar_feitico(feitico_contexto : FeiticoContexto) -> void:
	NetworkServer.jogador_lancar_feitico.rpc_id(Network.SERVER_ID, feitico_contexto.to_dict())

@rpc("authority", "call_local", "reliable")
func spawn_feitico(feitico_contexto_net : Dictionary) -> void:
	var feitico_contexto := FeiticoContexto.from_dict(feitico_contexto_net)
	spawnar_feitico.emit(feitico_contexto)
