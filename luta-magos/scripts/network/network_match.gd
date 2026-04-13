extends Node

signal spawnar_jogador

var dados_jogador_por_peer_id : Dictionary[int, DadosJogador] = {}

# -----------------------------------------------------------------------------
# Lobby
# -----------------------------------------------------------------------------

func criar_lobby() -> void:
	Network.create_server()
	TrocaCenaTemp.go_to_menu_partida()
	TrocaCenaTemp.partida.add_log("Lobby criado")
	Network.on_peer_connected.connect(_lobby_add_jogador)
	Network.on_peer_disconnected.connect(_lobby_rem_jogador)

func _lobby_add_jogador(peer_id: int) -> void:
	TrocaCenaTemp.partida.add_log("Jogador entrou")
	var dados_jog : DadosJogador = null
	dados_jogador_por_peer_id[peer_id] = dados_jog

func _lobby_rem_jogador(peer_id: int) -> void:
	if not dados_jogador_por_peer_id.has(peer_id): return
	
	var nome := dados_jogador_por_peer_id[peer_id].nome
	TrocaCenaTemp.partida.add_log("%s saiu (id %d)" % [nome, peer_id])
	
	dados_jogador_por_peer_id.erase(peer_id)

func entrar_lobby() -> void:
	Network.create_client()
	Network.on_connected_to_server.connect(_enviar_dados_jogador)
	# TODO: tela de conexao
	print("conectando ao servidor")

func _enviar_dados_jogador() -> void:
	var dados := DadosJogador.new()
	dados.peer_id     = multiplayer.get_unique_id()
	dados.nome = "Jogador 2"
	dados.grimorio = [1,2,3]
	dados.stats = {"level": 5, "xp": 1200}
	
	# Send to server
	register_player.rpc_id(1, dados.to_dict())
	
	TrocaCenaTemp.go_to_menu_partida()
	TrocaCenaTemp.partida.add_log("Entrou no lobby")

@rpc("any_peer", "call_remote", "reliable")
func register_player(dados: Dictionary) -> void:
	var sender_peer_id = multiplayer.get_remote_sender_id()
	
	# verifica se o jogador que mandou tem o mesmo peer_id
	if dados.get("peer_id") != sender_peer_id:
		push_warning("Mismatched peer_id from sender %d" % sender_peer_id)
		return

	var dados_jog := DadosJogador.from_dict(dados)
	dados_jogador_por_peer_id[sender_peer_id] = dados_jog
	TrocaCenaTemp.partida.add_log("%s entrou (id %d)" % [dados_jog.nome, sender_peer_id])

# -----------------------------------------------------------------------------
# Partida
# -----------------------------------------------------------------------------

func iniciar_partida() -> void:
	TrocaCenaTemp.go_to_game()
	
	#Network.on_peer_connected.connect(spawn_jogador)
	
	spawn_jogador(multiplayer.get_unique_id())

func spawn_jogador(id: int) -> void:
	emit_signal("spawnar_jogador", id)
