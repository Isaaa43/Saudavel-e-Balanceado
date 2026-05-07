extends Node

var main_game : Node
# TODO: criar solucao melhor
var partida : MenuPartida


var musica_player_time : float = 0.0
var musica_player : AudioStreamPlayer2D


const MENU_INICIAL = preload("uid://6als3mloubtk")
const MENU_PARTIDA = preload("uid://c2ppdl2yqxf16")

const GAME_ADM = preload("uid://cm7rbbwccvpap")

func _ready() -> void:
	main_game = get_node("/root/MainGame")

func go_to_menu_inicial() -> void:
	if musica_player and is_instance_valid(musica_player):
		musica_player_time = musica_player.get_playback_position()
	
	for c in main_game.get_children(): c.queue_free()
	var menu_inicial := MENU_INICIAL.instantiate()
	main_game.add_child(menu_inicial)
	# TODO: encontrar lugar melhor para colocar isso
	Network.end()

func go_to_menu_partida() -> void:
	if musica_player and is_instance_valid(musica_player):
		musica_player_time = musica_player.get_playback_position()
	
	for c in main_game.get_children(): c.queue_free()
	var menu_partida := MENU_PARTIDA.instantiate()
	# TODO: criar soluacao melhor
	partida = menu_partida
	main_game.add_child(menu_partida)

func go_to_game() -> void:
	if musica_player and is_instance_valid(musica_player):
		musica_player_time = musica_player.get_playback_position()
	
	for c in main_game.get_children(): if c is Control: c.queue_free()
	var game := GAME_ADM.instantiate()
	main_game.add_child(game)
