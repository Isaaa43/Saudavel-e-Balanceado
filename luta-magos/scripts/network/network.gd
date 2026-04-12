extends Node

signal on_peer_connected(peer_id)
signal on_peer_disconnected(peer_id)

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
	
	get_tree().multiplayer_poll = false

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

func _process(_delta: float) -> void:
	#if is_client and (not is_client_conected): return
	
	network_peer.poll()
	var packet_count := network_peer.get_available_packet_count()
	
	for i in packet_count:
		var peer_id := network_peer.get_packet_peer()
		var channel := network_peer.get_packet_channel()
		var mode    := network_peer.get_packet_mode()
		
		var packet := network_peer.get_packet()
		
		print("----- start ------")
		print("peer_id: ", peer_id)
		print("channel: ", channel)
		print("mode: ", mode)
		print("packet: ", packet)
		if packet:
			print("msg packet: ", bytes_to_var(packet))
		print("----- end   ------")

func send_data(id : int) -> void:
	var peer : ENetPacketPeer = network_peer.get_peer(id)
	var message := "oiee %d" % id
	var buffer : PackedByteArray = var_to_bytes(message)
	var channel := 0
	
	var flags : int = ENetPacketPeer.FLAG_RELIABLE
	
	peer.send(channel, buffer, flags)

func _on_peer_connected(peer_id) -> void:
	if peer_id == 1: return
	send_data(peer_id)
	emit_signal("on_peer_connected", peer_id)

func _on_peer_disconnected(peer_id) -> void:
	print("peer_disconnected id: ", peer_id)
	emit_signal("on_peer_disconnected")
	set_process(false) 

func _on_connected_to_server() -> void:
	#emit_signal("peer_connected", multiplayer.get_unique_id())
	print("connected_to_server")
