extends Node

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
signal spawnar_jogador(dados_jogador, peer_id)
signal spawnar_feitico(feitico_id : String, target_pos : Vector3)

# TODO: trocar para load map, ou load game
@rpc("authority", "call_local", "reliable")
func iniciar_partida() -> void:
	TrocaCenaTemp.go_to_game()
	await get_tree().process_frame
	print("iniciar_partida id:", multiplayer.get_unique_id())

@rpc("authority", "call_local", "reliable")
func spawn_jogador(dados_jog : DadosJogador) -> void:
	emit_signal("spawnar_jogador", dados_jog)

func lancar_feitico(feitico_id : String, target_pos : Vector3, target_node) -> void:
	NetworkServer.jogador_lancar_feitico.rpc_id(Network.SERVER_ID, feitico_id, target_pos)


@rpc("authority", "call_local", "reliable")
func spawn_feitico(feitico_id : String, target_pos : Vector3) -> void:
	emit_signal("spawnar_feitico", feitico_id, target_pos)
