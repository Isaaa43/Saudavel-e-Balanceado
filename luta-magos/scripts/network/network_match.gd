extends Node

signal spawnar_jogador

# -----------------------------------------------------------------------------
# Lobby
# -----------------------------------------------------------------------------

func criar_lobby() -> void:
	Network.create_server()
	TrocaCenaTemp.go_to_menu_partida()
	TrocaCenaTemp.partida.add_log("Lobby criado")
	Network.on_peer_connected.connect(func(_x): TrocaCenaTemp.partida.add_log("Jogador entrou"))

func entrar_lobby() -> void:
	Network.create_client()
	TrocaCenaTemp.go_to_menu_partida()
	TrocaCenaTemp.partida.add_log("Entrou no lobby")

# -----------------------------------------------------------------------------
# Partida
# -----------------------------------------------------------------------------

func iniciar_partida() -> void:
	TrocaCenaTemp.go_to_game()
	
	#Network.on_peer_connected.connect(spawn_jogador)
	
	spawn_jogador(multiplayer.get_unique_id())

func spawn_jogador(id: int) -> void:
	emit_signal("spawnar_jogador", id)
