extends Node

signal on_peer_connected(peer_id)
signal on_peer_disconnected(peer_id)
signal on_connected_to_server

const PORT			:= 54321
const IP_ADDR		:= "localhost"
const MAX_CLIENTS 	:= 2

var network_peer = ENetMultiplayerPeer.new()

var is_client : bool = false 

func start() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(func():   print("connection_failed"))
	multiplayer.server_disconnected.connect(func(): print("server_disconnected"))

func create_server() -> void:
	var err := network_peer.create_server(PORT, MAX_CLIENTS)
	if err == OK:
		print("server criado")
	else:
		print("server error code: ", err)
		return
	
	multiplayer.multiplayer_peer = network_peer
	set_process(true)

func create_client() -> void:
	var err := network_peer.create_client(IP_ADDR, PORT)
	if err == OK:
		print("cliente criado")
	else:
		print("cliente error code: ", err)
		return
	
	multiplayer.multiplayer_peer = network_peer
	set_process(true)
	#is_client = true

func _ready() -> void:
	set_process(false)

func _on_peer_connected(peer_id) -> void:
	if peer_id == 1: return
	emit_signal("on_peer_connected", peer_id)

func _on_peer_disconnected(peer_id) -> void:
	print("peer_disconnected id: ", peer_id)
	emit_signal("on_peer_disconnected")
	set_process(false) 

func _on_connected_to_server() -> void:
	print("connected_to_server")
	emit_signal("on_connected_to_server")
