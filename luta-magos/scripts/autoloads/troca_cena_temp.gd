extends Node

var main_game : Node
var Network : Node

const MENU_INICIAL = preload("uid://6als3mloubtk")
const MENU_PARTIDA = preload("uid://c2ppdl2yqxf16")

const GAME_ADM = preload("uid://cm7rbbwccvpap")

func _ready() -> void:
	main_game = get_node("/root/MainGame")
	Network = get_node("/root/MainGame/Network")

func go_to_menu_inicial() -> void:
	for c in main_game.get_children(): c.queue_free()
	var menu_inicial := MENU_INICIAL.instantiate()
	main_game.add_child(menu_inicial)

func go_to_menu_partida() -> void:
	for c in main_game.get_children(): c.queue_free()
	var menu_partida := MENU_PARTIDA.instantiate()
	main_game.add_child(menu_partida)

func go_to_game() -> void:
	for c in main_game.get_children(): if c is Control: c.queue_free()
	
	var game := GAME_ADM.instantiate()
	main_game.add_child(game)
