class_name NetworkServer
extends Node

signal spawnar_jogador(dados_jogador : DadosJogador)
signal jogador_votou_iniciar_partida(peer_id: int, voto: bool)

var dados_jogador_por_peer_id : Dictionary[int, DadosJogador] = {}

var partida_iniciada : bool = false

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
	Network.logs.add_conexao_texto("Lobby criado")
	Network.logs.add_conexao_texto("IP: %s" % Network.IP_ADDR)
	Network.logs.add_conexao_texto("Port: %d" % Network.PORT)
	# salva o peer_id do server nos dados do jog
	Network.client.dados_jogador.peer_id = Network.SERVER_ID
	# cria os dados do jogador que criou o lobby
	var dados_jog := Network.client.dados_jogador
	_registrar_jogador_peer_id(dados_jog, Network.SERVER_ID)

func _lobby_add_jogador(peer_id: int) -> void:
	Network.logs.add_conexao_texto_peer("Jogador entrando", peer_id)
	# vai receber o rpc

func _lobby_rem_jogador(peer_id: int) -> void:
	if not dados_jogador_por_peer_id.has(peer_id): return
	
	var nome := dados_jogador_por_peer_id[peer_id].nome
	Network.logs.add_conexao_texto_peer("%s saiu" % nome, peer_id)
	dados_jogador_por_peer_id.erase(peer_id)

@rpc("any_peer", "call_remote", "reliable")
func registrar_jogador(dados: Dictionary) -> void:
	var sender_peer_id = multiplayer.get_remote_sender_id()
	
	# verifica se o jogador que mandou tem o mesmo peer_id
	if dados.get("peer_id") != sender_peer_id:
		push_warning("Mismatched peer_id from sender %d" % sender_peer_id)
		return

	var dados_jog := DadosJogador.from_dict(dados)
	_registrar_jogador_peer_id(dados_jog, sender_peer_id)
	# envia de volta ao jogador as infos do lobby
	_enviar_info_lobby(sender_peer_id)

func _registrar_jogador_peer_id(dados_jog : DadosJogador, peer_id : int) -> void:
	if dados_jog.peer_id != peer_id:
		print("_registrar_jogador_peer_id %d != %d" % [dados_jog.peer_id, peer_id])
	dados_jogador_por_peer_id[peer_id] = dados_jog
	Network.logs.add_conexao_texto_peer("%s entrou" % [dados_jog.nome], peer_id)

func _enviar_info_lobby(jog_peer_id: int) -> void:
	var logs_server: Array[String] = Network.logs.get_recent_logs_list()
	Network.client.receber_info_lobby.rpc_id(jog_peer_id, logs_server)
# -----------------------------------------------------------------------------
# Partida
# -----------------------------------------------------------------------------

func iniciar_partida() -> void:
	if not multiplayer.is_server(): return
	
	if partida_iniciada: return
	partida_iniciada = true
	
	for peer_id : int in dados_jogador_por_peer_id.keys():
		Network.client.iniciar_partida.rpc_id(peer_id)
	
	# TODO: solucao melhor que essa do timer
	await get_tree().create_timer(0.2).timeout
	_server_iniciar_partida()

func _server_iniciar_partida() -> void:
	# emite o sinal para spawnar cada jogador
	for dados_jog : DadosJogador in dados_jogador_por_peer_id.values():
		spawnar_jogador.emit(dados_jog)

## 
@rpc("any_peer", "call_remote", "reliable")
func get_dados_jogador_do_jogador(jogador_peer_id: int) -> void:
	var peer_id_req = multiplayer.get_remote_sender_id()
	var dados_jog = dados_jogador_por_peer_id[jogador_peer_id]
	Network.client.receber_dados_jogador.rpc_id(peer_id_req, jogador_peer_id, dados_jog.to_dict())

## Cliente vota true (se sim), false (nao quer) iniciar a partida
@rpc("any_peer", "call_remote", "unreliable")
func jogador_votar_iniciar_partida(voto: bool) -> void:
	var peer_id_jog = multiplayer.get_remote_sender_id()
	jogador_votou_iniciar_partida.emit(peer_id_jog, voto)

## Transmite a quantidade de votos atuais para todos os jogadores conectados
func transmitir_votos_partida(qtde_votos: int) -> void:
	# somente para o server executar
	if not multiplayer.is_server(): return
	# envia os votos para cada peer
	for peer_id : int in dados_jogador_por_peer_id.keys():
		Network.client.receber_votos_partida.rpc_id(peer_id, qtde_votos)

# Partida Rolando
# -----------------------------------------------------------------------------

## Chama o server para terminar a partida
@rpc("any_peer", "reliable")
func pedir_terminar_partida() -> void:
	# somente para o server executar
	if not multiplayer.is_server(): return
	# server terminar a partida
	_server_terminar_partida()

## Broadcast do server para todos os peers, de terminar a partida
func _server_terminar_partida() -> void:
	partida_iniciada = false
	# transmite para todos os outros jogadores
	for peer_id : int in dados_jogador_por_peer_id.keys():
		# pular o servidor
		if peer_id != Network.SERVER_ID:
			Network.client.receber_terminar_partida.rpc_id(peer_id)
	# finalizar o servidor por ultimo
	await get_tree().create_timer(0.2).timeout
	Network.client.receber_terminar_partida()

@rpc("any_peer", "call_local", "reliable")
func jogador_lancar_feitico(feitico_contexto_net: Dictionary) -> void:
	if not multiplayer.is_server(): return
	
	for peer_id : int in dados_jogador_por_peer_id.keys():
		Network.client.spawn_feitico.rpc_id(peer_id, feitico_contexto_net)

@rpc("any_peer", "call_local", "reliable")
func avisar_jogador_morreu() -> void:
	if not multiplayer.is_server(): return
	var peer_id_req = multiplayer.get_remote_sender_id()
	
	for peer_id : int in dados_jogador_por_peer_id.keys():
		Network.client.matar_jogador.rpc_id(peer_id, peer_id_req)

func anunciar_ganhador(peer_id_ganhador: int) -> void:
	for peer_id : int in dados_jogador_por_peer_id.keys():
		Network.client.receber_ganhador.rpc_id(peer_id, peer_id_ganhador)

# -----------------------------------------------------------------------------
# Salvar dados
# -----------------------------------------------------------------------------

func salvar_decks() -> void:
	if not multiplayer.is_server(): return
	
	for peer_id : int in dados_jogador_por_peer_id.keys():
		Network.client.pedir_deck.rpc_id(peer_id)

@rpc("any_peer", "call_local", "reliable")
func receber_deck(lista_feiticos_id: String) -> void:
	var peer_id_req = multiplayer.get_remote_sender_id()
	SaveData.registrar_deck_batch(peer_id_req, lista_feiticos_id)
