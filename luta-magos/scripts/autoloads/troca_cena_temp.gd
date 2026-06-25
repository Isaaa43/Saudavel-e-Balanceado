extends Node

var main_game : Node
# TODO: criar solucao melhor
var partida : MenuPartida

const MENU_INICIAL = preload("uid://6als3mloubtk")
const MENU_PARTIDA = preload("uid://c2ppdl2yqxf16")
const MENU_DECK = preload("uid://djncp32jv7ppr")
const MENU_TREINO = preload("uid://uls6035prre4")

const GAME_ADM = preload("uid://cm7rbbwccvpap")

var jogo_iniciado : bool = false

func _ready() -> void:
	main_game = get_node("/root/MainGame")
	await get_tree().create_timer(0.1).timeout
	jogo_iniciado = true

func go_to_menu_inicial() -> void:
	if Input.get_mouse_mode() != Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	for c in main_game.get_children(): c.queue_free()
	var menu_inicial := MENU_INICIAL.instantiate()
	main_game.add_child(menu_inicial)
	# TODO: encontrar lugar melhor para colocar isso
	Network.end()

func go_to_menu_partida() -> void:
	for c in main_game.get_children(): c.queue_free()
	var menu_partida := MENU_PARTIDA.instantiate()
	# TODO: criar soluacao melhor
	partida = menu_partida
	main_game.add_child(menu_partida)

func go_to_game() -> void:
	for c in main_game.get_children(): if c is Control: c.queue_free()
	
	var game := GAME_ADM.instantiate()
	main_game.add_child(game)

func menu_deck() -> void:
	for c in main_game.get_children(): c.queue_free()
	var menu_deck := MENU_DECK.instantiate()
	# TODO: criar soluacao melhor
	main_game.add_child(menu_deck)

func go_to_menu_treino() -> void:
	for c in main_game.get_children(): c.queue_free()
	var menu_treino := MENU_TREINO.instantiate()
	# TODO: criar soluacao melhor
	main_game.add_child(menu_treino)

func go_to_treino() -> void:
	Network.start_network_treino()
	for c in main_game.get_children(): if c is Control: c.queue_free()
	var game := GAME_ADM.instantiate()
	
	game.game_loaded.connect(_start_treino)
	
	main_game.add_child(game)

func _start_treino() -> void:
	# hack para spawnar jogador
	var dados_jog: DadosJogador = Network.client.dados_jogador
	dados_jog.peer_id = 1
	Network.server.spawnar_jogador.emit(dados_jog)
