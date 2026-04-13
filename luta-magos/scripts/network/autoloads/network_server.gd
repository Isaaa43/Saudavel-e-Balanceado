extends Node

signal spawnar_jogador(dados_jogador, peer_id)

var dados_jogador_por_peer_id : Dictionary[int, DadosJogador] = {}

func _ready() -> void:
	_ready_lobby()

# -----------------------------------------------------------------------------
# Lobby
# -----------------------------------------------------------------------------

func _ready_lobby() -> void:
	Network.server_peer_connected.connect(_lobby_add_jogador)
	Network.server_peer_disconnected.connect(_lobby_rem_jogador)

func criar_lobby() -> void:
	Network.create_server()
	TrocaCenaTemp.go_to_menu_partida()
	LogsAdm.add_conexao_texto("Lobby criado")
	# cria os dados do jogador que criou o lobby
	var dados_jog := NetworkClient.dados_jogador
	_registrar_jogador_peer_id(dados_jog, Network.SERVER_ID)

func _lobby_add_jogador(peer_id: int) -> void:
	LogsAdm.add_conexao_texto_peer("Jogador entrando", peer_id)
	# vai receber o rpc

func _lobby_rem_jogador(peer_id: int) -> void:
	if not dados_jogador_por_peer_id.has(peer_id): return
	
	var nome := dados_jogador_por_peer_id[peer_id].nome
	
	LogsAdm.add_conexao_texto_peer("%s saiu" % nome, peer_id)
	
	dados_jogador_por_peer_id.erase(peer_id)

@rpc("any_peer", "call_remote", "reliable")
func registrar_jogador(dados: Dictionary) -> void:
	var sender_peer_id = multiplayer.get_remote_sender_id()
	
	# verifica se o jogador que mandou tem o mesmo peer_id
	if dados.get("peer_id") != sender_peer_id:
		push_warning("Mismatched peer_id from sender %d" % sender_peer_id)
		return

	print("dados_jog ", dados)
	var dados_jog := DadosJogador.from_dict(dados)
	_registrar_jogador_peer_id(dados_jog, sender_peer_id)

func _registrar_jogador_peer_id(dados_jog : DadosJogador, peer_id : int) -> void:
	dados_jogador_por_peer_id[peer_id] = dados_jog
	LogsAdm.add_conexao_texto_peer("%s entrou" % [dados_jog.nome], peer_id)

# -----------------------------------------------------------------------------
# Partida
# -----------------------------------------------------------------------------

func iniciar_partida() -> void:
	for peer_id : int in dados_jogador_por_peer_id.keys():
		_peer_iniciar_partida.rpc_id(peer_id)

@rpc("authority", "call_local", "reliable")
func _peer_iniciar_partida() -> void:
	TrocaCenaTemp.go_to_game()
	
	await get_tree().process_frame
	
	print("iniciar_partida id:", multiplayer.get_unique_id())
	
	for peer_id : int in dados_jogador_por_peer_id.keys():
		var dados_jog : DadosJogador = dados_jogador_por_peer_id[peer_id]
		_spawn_jogador(dados_jog, peer_id)

func _spawn_jogador(dados_jog : DadosJogador, peer_id: int) -> void:
	emit_signal("spawnar_jogador", dados_jog, peer_id)

## Chama o server para terminar a partida
func terminar_partida() -> void:
	if multiplayer.is_server():
		_server_terminar_partida()
	else:
		_server_terminar_partida.rpc_id(Network.SERVER_ID)

## Broadcast de terminar a partida para todos os peers
@rpc("any_peer", "reliable")
func _server_terminar_partida() -> void:
	for peer_id : int in dados_jogador_por_peer_id.keys():
		print("peer id: ", peer_id)
		_peer_terminar_partida.rpc_id(peer_id)

## Cada peer termina sua partida
@rpc("authority", "call_local", "reliable")
func _peer_terminar_partida() -> void:
	if multiplayer.is_server():
		# TODO: solucao melhor que essa do timer
		await get_tree().create_timer(0.2).timeout
	#TODO: Network.server_disconnected ?
	TrocaCenaTemp.go_to_menu_inicial()
