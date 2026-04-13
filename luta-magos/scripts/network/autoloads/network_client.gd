extends Node

# -----------------------------------------------------------------------------
# Lobby
# -----------------------------------------------------------------------------

func entrar_lobby() -> void:
	Network.create_client()
	Network.on_connected_to_server.connect(_enviar_dados_jogador)
	# TODO: tela de conexao
	print("conectando ao servidor")

func _enviar_dados_jogador() -> void:
	var dados := criar_dados_jogador()
	
	# Send to server
	NetworkServer.registrar_jogador.rpc_id(Network.SERVER_ID, dados.to_dict())
	
	TrocaCenaTemp.go_to_menu_partida()
	TrocaCenaTemp.partida.add_log("Entrou no lobby")

func criar_dados_jogador() -> DadosJogador:
	var dados := DadosJogador.new()
	dados.peer_id     = multiplayer.get_unique_id()
	dados.nome = "Jogador 2"
	dados.grimorio = [1,2,3]
	dados.stats = {"level": 5, "xp": 1200}
	return dados

# -----------------------------------------------------------------------------
# Partida
# -----------------------------------------------------------------------------
