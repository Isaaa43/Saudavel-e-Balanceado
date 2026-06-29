class_name NetworkClient
extends Node

signal ajustar_dados_jogador(jog_peer_id: int, dados_jog: DadosJogador)
signal morreu_jogador(jog_peer_id: int)
signal ajustar_votos_iniciar_partida(qtde_votos: int)

@onready var dados_jogador : DadosJogador = criar_dados_jogador()

func _ready() -> void:
	_ready_lobby()
# -----------------------------------------------------------------------------
# Lobby
# -----------------------------------------------------------------------------

func _ready_lobby() -> void:
	Network.client_connection_ok.connect(_enviar_dados_jogador)
	Network.client_server_disconnected.connect(_terminar_partida)
	
func entrar_lobby() -> void:
	Network.create_client()
	# atualiza os dados do jogador
	dados_jogador.peer_id = multiplayer.get_unique_id()
	
	Network.logs.add_conexao_texto("Tentado entrar no lobby")
	
	# TODO: tela de conexao
	print("conectando ao servidor")

func _enviar_dados_jogador() -> void:	
	# Send to server
	Network.server.registrar_jogador.rpc_id(Network.SERVER_ID, dados_jogador.to_dict())
	
	TrocaCenaTemp.go_to_menu_partida()
	Network.logs.add_conexao_texto("Entrou no lobby")

func criar_dados_jogador() -> DadosJogador:
	var dados := DadosJogador.new()
	dados.peer_id	= -1
	dados.nome 		= "Jogador"
	dados.grimorio 	= [1,2,3]
	dados.stats 	= {"level": 5, "xp": 1200}
	return dados

@rpc("authority", "call_local", "reliable")
func receber_info_lobby(logs_server: Array[String]) -> void:
	Network.logs.append_logs(logs_server)

func votar_iniciar_partida(voto: bool = true) -> void:
	if multiplayer.is_server():
		Network.server.jogador_votar_iniciar_partida(voto)
	else:
		Network.server.jogador_votar_iniciar_partida.rpc_id(Network.SERVER_ID, voto)

@rpc("authority", "call_local", "reliable")
func receber_votos_partida(qtde_votos: int) -> void:
	ajustar_votos_iniciar_partida.emit(qtde_votos)

# -----------------------------------------------------------------------------
# Partida
# -----------------------------------------------------------------------------

signal spawnar_feitico(feitico_contexto : FeiticoContexto)

# TODO: trocar para load map, ou load game
@rpc("authority", "call_local", "reliable")
func iniciar_partida() -> void:
	Network.logs.add_conexao_texto("Partida Iniciada!")
	TrocaCenaTemp.go_to_game()
	await get_tree().process_frame
	print("iniciar_partida id:", multiplayer.get_unique_id())

func pedir_terminar_partida() -> void:
	# Multiplayer offline
	if not Network.is_peer_connected():
		_terminar_partida()
	
	if multiplayer.is_server():
		Network.server.pedir_terminar_partida()
	else:
		Network.server.pedir_terminar_partida.rpc_id(Network.SERVER_ID)

## Cada peer termina sua partida
@rpc("authority", "call_local", "reliable")
func receber_terminar_partida() -> void:
	if not multiplayer.is_server():
		# TODO: solucao melhor que essa do timer
		await get_tree().create_timer(0.2).timeout
	_terminar_partida()

func _terminar_partida() -> void:
	Network.logs.add_conexao_texto("Partida Finalizada")
	
	if multiplayer.is_server():
		SaveData.encerrar_partida()
	
	#TODO: Network.server_disconnected ?
	#TrocaCenaTemp.go_to_menu_inicial()
	TrocaCenaTemp.go_to_menu_partida()

func pedir_dados_jogador_do_jogador(jogador_peer_id: int) -> void:
	Network.server.get_dados_jogador_do_jogador.rpc_id(Network.SERVER_ID, jogador_peer_id)

@rpc("authority", "call_local", "reliable")
func receber_dados_jogador(jogador_peer_id: int, dados_jog_dict: Dictionary) -> void:
	var dados_jog := DadosJogador.from_dict(dados_jog_dict)
	ajustar_dados_jogador.emit(jogador_peer_id, dados_jog)

func lancar_feitico(feitico_contexto : FeiticoContexto) -> void:
	Network.server.jogador_lancar_feitico.rpc_id(Network.SERVER_ID, feitico_contexto.to_dict())

@rpc("authority", "call_local", "reliable")
func spawn_feitico(feitico_contexto_net : Dictionary) -> void:
	var feitico_contexto := FeiticoContexto.from_dict(feitico_contexto_net)
	spawnar_feitico.emit(feitico_contexto)

func avisar_jogador_morreu() -> void:
	Network.server.avisar_jogador_morreu.rpc_id(Network.SERVER_ID)

@rpc("authority", "call_local", "reliable")
func matar_jogador(jogador_peer_id: int) -> void:
	Network.logs.add_conexao_texto("Jogador Morto (id: %d)" % jogador_peer_id)
	print("matar_jogador ", jogador_peer_id, " meu id ", multiplayer.get_unique_id())
	morreu_jogador.emit(jogador_peer_id)


# -----------------------------------------------------------------------------
# Salvar dados
# -----------------------------------------------------------------------------

@rpc("authority", "call_local", "reliable")
func pedir_deck() -> void:
	var linha : String = ""
	for feitico_id : String in GlobalDeck.feiticos_id_escolhidos:
		linha += "%s," % feitico_id
	Network.server.receber_deck.rpc_id(Network.SERVER_ID, linha)
