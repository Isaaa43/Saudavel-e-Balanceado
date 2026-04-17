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
signal spawn_feitico(feitico_id : String, target_pos : Vector3)

func lancar_feitico(feitico_id : String, target_pos : Vector3, target_node) -> void:
	NetworkServer.jogador_lancar_feitico.rpc_id(Network.SERVER_ID, feitico_id, target_pos)



@rpc("authority", "call_local", "reliable")
func spawnar_feitico(feitico_id : String, target_pos : Vector3) -> void:
	emit_signal("spawn_feitico", feitico_id, target_pos)
