class_name DisplayGrimorio
extends Control

signal grimorio_atualizado

@onready var img_card_ref: TextureRect = $ScrollContainer/ImgCardRef
@onready var grid_deck: GridContainer = $ScrollContainer/GridDeck

func _ready() -> void:
	# mostra o grimorio atual do jogador
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
	
	# avisa que o grimorio foi atualizado
	grimorio_atualizado.emit()


const MENU_DECK = preload("uid://djncp32jv7ppr")
func _on_button_deck_pressed() -> void:
	var menu_deck : MenuDeck = MENU_DECK.instantiate()
	get_parent().add_child(menu_deck)
	menu_deck.move_to_front()
	menu_deck.sair_menu_deck = _fechar_menu_deck.bind(menu_deck)

func _fechar_menu_deck(menu_deck: MenuDeck) -> void:
	menu_deck.queue_free()
	_mostrar_deck()
