class_name JogadoresAdm
extends Node

signal recebido_jogador_authority(jogador: Jogador)
signal recebido_dados_jog_authority(dados_jog: DadosJogador)

@export var JOGADOR_REF : PackedScene

@onready var jogadores_node_pai: Node = $Jogadores

var jogadores_por_peer_id: Dictionary[int, Jogador] = {}

func _ready() -> void:
	if multiplayer.is_server():
		_server_ready()
	else:
		_client_ready()

func _server_ready() -> void:
	# server spawna os jogadores
	Network.server.spawnar_jogador.connect(_server_spawnar_jogador)

func _client_ready() -> void:
	# client ajusta dados dos jogadores
	Network.client.ajustar_dados_jogador.connect(_client_set_dados_jogador)

func _server_spawnar_jogador(dados_jog : DadosJogador) -> void:
	var peer_id : int = dados_jog.peer_id
	print("spawnar_jogador dados: ", dados_jog, " id: ", peer_id)

	var jogador : Jogador = JOGADOR_REF.instantiate()
	jogador.name = str(peer_id)
	jogador.dados_jogador = dados_jog
	
	jogadores_node_pai.add_child(jogador, true)
	jogadores_por_peer_id[peer_id] = jogador
	# se for o jogador desse PC, emitir jogador e dados
	if _verificar_authority_jogador(peer_id):
		recebido_jogador_authority.emit(jogador)
		recebido_dados_jog_authority.emit(dados_jog)
	
	jogador.global_position = Vector3.ONE * randi_range(2, 5)
	jogador.velocity = Vector3.ZERO

func _client_set_dados_jogador(jog_peer_id: int, dados_jog: DadosJogador) -> void:
	if not jogadores_por_peer_id.has(jog_peer_id): return
	# adiciona os dados do jogador, ao jogador
	var jogador: Jogador = jogadores_por_peer_id[jog_peer_id]
	jogador.dados_jogador = dados_jog
	# se for o jogador desse PC, emitir os dados do jog
	if _verificar_authority_jogador(jog_peer_id):
		recebido_dados_jog_authority.emit(dados_jog)

func _on_multiplayer_spawner_jogadores_spawned(node: Node) -> void:
	# se for o server pare
	if multiplayer.is_server(): return
	# se o nodo que esta tentando spawnar nao for um jogador, pare
	if not (node is Jogador): return
	
	# adiciona na lista
	var jogador : Jogador = node
	var jog_peer_id : int = int(jogador.name)
	jogadores_por_peer_id[jog_peer_id] = jogador
	# se for o jogador desse PC, emitir jogador
	if _verificar_authority_jogador(jog_peer_id):
		recebido_jogador_authority.emit(jogador)
	# peca para o server os dados desse jogador
	Network.client.pedir_dados_jogador_do_jogador(jog_peer_id)

## Retorna true se o jog_peer_id for a autoridade desse PC
func _verificar_authority_jogador(jog_peer_id: int) -> bool:
	var authority_peer_id: int = Network.client.dados_jogador.peer_id
	if authority_peer_id == jog_peer_id:
		return true
	return false

func get_jogador_peer_id(peer_id: int) -> Jogador:
	if jogadores_por_peer_id.has(peer_id):
		return jogadores_por_peer_id[peer_id]
	return null
