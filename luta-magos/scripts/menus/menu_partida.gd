extends Control
class_name MenuPartida

@onready var label_jog_prontos: Label = %LabelJogProntos
@onready var button_comecar: Button = $%ButtonComecar
@onready var button_sair: Button = $%ButtonSair

@onready var label_log: Label = $VBoxLogs/LabelLog

@onready var grid_deck: GridContainer = $Deck/ScrollContainer/GridDeck
@onready var img_card_ref: TextureRect = $Deck/ScrollContainer/ImgCardRef

var votos_partida_por_peer_id : Dictionary[int, bool] = {}

func _ready() -> void:
	# TODO:
	button_comecar.grab_focus()
	# atualiza os logs da conexao visualmente
	Network.logs.update_conexao.connect(_update_logs)
	_update_logs()
	# mostra o grimorio atual do jogador
	_mostrar_deck()
	# servidor contabilizar os votos
	Network.server.jogador_votou_iniciar_partida.connect(_receber_voto)
	# atualiza os votos para iniciar partida
	Network.client.ajustar_votos_iniciar_partida.connect(_update_votos)
	_update_votos()

# Votar Comecar Partida
# -----------------------------------------------------------------------------

func atualizar_botao_comecar_partida() -> void:
	# verifica se o jogador nao precisa de algo antes de comecar a partida
	var valido: bool = GlobalDeck.deck_size == GlobalDeck.get_deck().size()
	button_comecar.disabled = not valido

func _update_votos(qtde_votos: int = 0) -> void:
	label_jog_prontos.text = "Jogadores prontos:\n %d / %d" % [qtde_votos, 2]

func _on_button_comecar_toggled(toggled_on: bool) -> void:
	Network.client.votar_iniciar_partida(toggled_on)

# SERVIDOR: Lidar com os votos da Partida
# -----------------------------------------------------------------------------

var esta_cooldown_transmissao_voto: bool = false

func _receber_voto(peer_id_jog: int, voto: bool) -> void:
	if not multiplayer.is_server(): return
	
	# atualiza o voto desse jogador
	votos_partida_por_peer_id[peer_id_jog] = voto
	# verifica se tem todos os votos
	var qtde_votos: int = _contar_votos_iniciar_partida()
	
	# verifica se pode iniciar a partida
	if _verificar_votos_necessarios():
		get_tree().create_timer(2.0).timeout.connect(_tentar_iniciar_partida)
	
	# se estiver no cooldown, nao transmita 
	if esta_cooldown_transmissao_voto: return
	# transmita para todos os jogadores a quantidade de votos
	Network.server.transmitir_votos_partida(qtde_votos)
	# entre no cooldown
	esta_cooldown_transmissao_voto = true
	# sair do cooldown dps de um tempo
	get_tree().create_timer(1.0).timeout.connect(
		func(): esta_cooldown_transmissao_voto = false )

func _contar_votos_iniciar_partida() -> int:
	var qtde_votos: int = 0
	for voto:bool in votos_partida_por_peer_id.values():
		if voto: qtde_votos += 1
	return qtde_votos

func _verificar_votos_necessarios() -> bool:
	var qtde_votos: int = _contar_votos_iniciar_partida()
	return qtde_votos == 2

func _tentar_iniciar_partida() -> void:
	if not multiplayer.is_server(): return
	
	if _verificar_votos_necessarios():
		Network.server.iniciar_partida()

# Sair
# -----------------------------------------------------------------------------

func _on_button_sair_pressed() -> void:
	TrocaCenaTemp.go_to_menu_inicial()

# Menu Deck
# -----------------------------------------------------------------------------

func _mostrar_deck() -> void:
	for c in grid_deck.get_children():
		c.queue_free()
	
	# adiciona as imagens das cartas
	for card: MenuDeck.CardData in GlobalDeck.cards_escolhidos:
		var img := img_card_ref.duplicate()
		img.texture = card.icone
		grid_deck.add_child(img)
		img.show()
	
	# atualiza o botao comecar
	atualizar_botao_comecar_partida()


const MENU_DECK = preload("uid://djncp32jv7ppr")
func _on_button_deck_pressed() -> void:
	var menu_deck : MenuDeck = MENU_DECK.instantiate()
	add_child(menu_deck)
	menu_deck.move_to_front()
	menu_deck.sair_menu_deck = _fechar_menu_deck.bind(menu_deck)

func _fechar_menu_deck(menu_deck: MenuDeck) -> void:
	menu_deck.queue_free()
	_mostrar_deck()

# Logs de Conexao
# -----------------------------------------------------------------------------

func _update_logs() -> void:
	label_log.text = Network.logs.get_recent_logs_string()
