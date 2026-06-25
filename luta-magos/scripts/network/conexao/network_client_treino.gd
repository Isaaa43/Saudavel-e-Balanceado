class_name NetworkClientTreino
extends NetworkClient

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
	
	# TODO: tela de conexao
	print("conectando ao servidor")

func _enviar_dados_jogador() -> void:	
	pass

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

# TODO: trocar para load map, ou load game
@rpc("authority", "call_local", "reliable")
func iniciar_partida() -> void:
	TrocaCenaTemp.go_to_game()
	await get_tree().process_frame
	print("iniciar_partida id:", multiplayer.get_unique_id())

func pedir_terminar_partida() -> void:
	_terminar_partida()

## Cada peer termina sua partida
@rpc("authority", "call_local", "reliable")
func receber_terminar_partida() -> void:
	_terminar_partida()

func _terminar_partida() -> void:
	TrocaCenaTemp.go_to_menu_treino()

func pedir_dados_jogador_do_jogador(jogador_peer_id: int) -> void:
	pass

@rpc("authority", "call_local", "reliable")
func receber_dados_jogador(jogador_peer_id: int, dados_jog_dict: Dictionary) -> void:
	var dados_jog := DadosJogador.from_dict(dados_jog_dict)
	ajustar_dados_jogador.emit(jogador_peer_id, dados_jog)

func lancar_feitico(feitico_contexto : FeiticoContexto) -> void:
	spawnar_feitico.emit(feitico_contexto)

func spawn_feitico(feitico_contexto_net : Dictionary) -> void:
	var feitico_contexto := FeiticoContexto.from_dict(feitico_contexto_net)
	spawnar_feitico.emit(feitico_contexto)

func avisar_jogador_morreu() -> void:
	matar_jogador(multiplayer.get_unique_id())

func matar_jogador(jogador_peer_id: int) -> void:
	print("matar_jogador ", jogador_peer_id, " meu id ", multiplayer.get_unique_id())
	morreu_jogador.emit(jogador_peer_id)


# -----------------------------------------------------------------------------
# Salvar dados
# -----------------------------------------------------------------------------

func pedir_deck() -> void:
	pass
