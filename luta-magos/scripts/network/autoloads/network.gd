extends Node

signal server_peer_connected(peer_id)
signal server_peer_disconnected(peer_id)
signal client_connection_ok
signal client_connection_failed
signal client_server_disconnected

const SERVER_ID := 1

const PORT			:= 54321
const IP_ADDR		:= "localhost"
const MAX_CLIENTS 	:= 2

func _ready() -> void:
	set_process(false)
	#
	multiplayer.peer_connected.connect(_server_peer_connected)
	multiplayer.peer_disconnected.connect(_server_peer_disconnected)
	multiplayer.connected_to_server.connect(_client_connection_ok)
	multiplayer.connection_failed.connect(_client_connection_failed)
	multiplayer.server_disconnected.connect(_client_server_disconnected)

# ------------------------------------------------------------------------------
# Iniciar Conexao
# ------------------------------------------------------------------------------

func create_server() -> void:
	var network_peer = ENetMultiplayerPeer.new()
	var err := network_peer.create_server(PORT, MAX_CLIENTS)
	if err == OK:
		print("server criado")
	else:
		print("server error code: ", err)
		return
	
	multiplayer.multiplayer_peer = network_peer
	set_process(true)

func create_client() -> void:
	var network_peer = ENetMultiplayerPeer.new()
	var err := network_peer.create_client(IP_ADDR, PORT)
	if err == OK:
		print("cliente criado")
	else:
		print("cliente error code: ", err)
		return
	
	multiplayer.multiplayer_peer = network_peer
	set_process(true)

# ------------------------------------------------------------------------------
# Sinais
# ------------------------------------------------------------------------------
func _server_peer_connected(peer_id) -> void:
	if peer_id == 1: return
	print("server_peer_connected id: ", peer_id)
	server_peer_connected.emit(peer_id)

func _server_peer_disconnected(peer_id) -> void:
	print("peer_disconnected id: ", peer_id)
	server_peer_disconnected.emit(peer_id)
	set_process(false) 

func _client_connection_ok() -> void:
	print("connection_to_server_ok")
	client_connection_ok.emit()

func _client_connection_failed() -> void:
	print("connection_to_server_failed")
	client_connection_failed.emit()

func _client_server_disconnected() -> void:
	print("client_server_disconnected")
	client_server_disconnected.emit()
# ------------------------------------------------------------------------------
# Encerrar Conexao
# ------------------------------------------------------------------------------
func end() -> void:
	print("END SERVER")
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	
	# disconnect everything
	#for signal_info in multiplayer.get_signal_list():
		#var connections = multiplayer.get_signal_connection_list(signal_info.name)
		#for connection in connections:
			#var sig = connection.signal
			#sig.disconnect(connection.callable)

func is_peer_connected() -> bool:
	if multiplayer.get_peers().is_empty(): return false
	if multiplayer.get_unique_id() == 0: return false
	
	return true
