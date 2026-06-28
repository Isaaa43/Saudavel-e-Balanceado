extends Control
class_name MenuPartida

@onready var button_comecar: Button = $VBoxPartida/ButtonComecar
@onready var button_sair: Button = $VBoxPartida/ButtonSair

@onready var label_log: Label = $VBoxLogs/LabelLog

@onready var grid_deck: GridContainer = $Deck/ScrollContainer/GridDeck
@onready var img_card_ref: TextureRect = $Deck/ScrollContainer/ImgCardRef

func _ready() -> void:
	# TODO:
	button_comecar.grab_focus()
	# atualiza os logs da conexao visualmente
	Network.logs.update_conexao.connect(_update_logs)
	# mostra o grimório atual do jogador
	_mostrar_deck()


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

func atualizar_botao_comecar_partida() -> void:
	
	var valido: bool = GlobalDeck.deck_size == GlobalDeck.get_deck().size()
	button_comecar.disabled = not valido
	
	# TODO: Por enquato vai isso, mas no futuro fazer um sistema de voto, tipo ready DBD
	# somente o server pode iniciar a partida
	#button_comecar.disabled = not multiplayer.is_server()
	return

func _on_button_comecar_pressed() -> void:
	if not is_multiplayer_authority(): return
	Network.server.iniciar_partida()

func _on_button_sair_pressed() -> void:
	TrocaCenaTemp.go_to_menu_inicial()


# -- Menu Deck --
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
