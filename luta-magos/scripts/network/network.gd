extends Node

const PORT			:= 54321
const IP_ADDR		:= "localhost"
const MAX_CLIENTS 	:= 2

var network_peer = ENetMultiplayerPeer.new()

var is_client : bool = false 
var is_client_conected : bool = false

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(
		func(x):
			print("peer_disconnected id: ", x)
			#is_client_conected = false )
			set_process(false) )
	multiplayer.connected_to_server.connect(func(): print("connected_to_server"))
	multiplayer.connection_failed.connect(func():   print("connection_failed"))
	multiplayer.server_disconnected.connect(func(): print("server_disconnected"))
	
	get_tree().multiplayer_poll = false
	
	set_process(false)
	

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
	#is_client_conected = true


func _process(_delta: float) -> void:
	if is_client and (not is_client_conected): return
	
	network_peer.poll()
	var packet_count := network_peer.get_available_packet_count()
	
	for i in packet_count:
		var peer_id := network_peer.get_packet_peer()
		var channel := network_peer.get_packet_channel()
		var mode    := network_peer.get_packet_mode()
		
		var packet := network_peer.get_packet()
		
		print("-----------")
		print("peer_id: ", peer_id)
		print("channel: ", channel)
		print("mode: ", mode)
		print("packet: ", packet)
		print("msg packet: ", bytes_to_var(packet))
		print("-----------")

func send_data(id : int) -> void:
	var peer : ENetPacketPeer = network_peer.get_peer(id)
	var message := "oiee %d" % id
	var buffer : PackedByteArray = var_to_bytes(message)
	var channel := 0
	
	var flags : int = ENetPacketPeer.FLAG_RELIABLE
	
	peer.send(channel, buffer, flags)

func _on_peer_connected(id : int) -> void:
	send_data(id)
