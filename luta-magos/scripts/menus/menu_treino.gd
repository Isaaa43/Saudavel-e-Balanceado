class_name MenuTreino
extends Control

@onready var button_comecar: Button = $VBoxPartida/ButtonComecar

@onready var grid_deck: GridContainer = $Deck/ScrollContainer/GridDeck
@onready var img_card_ref: TextureRect = $Deck/ScrollContainer/ImgCardRef

func _ready() -> void:
	# TODO:
	button_comecar.grab_focus()
	
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


func _on_button_comecar_pressed() -> void:
	TrocaCenaTemp.go_to_treino()

func _on_button_sair_pressed() -> void:
	TrocaCenaTemp.go_to_menu_inicial()

const MENU_DECK = preload("uid://djncp32jv7ppr")
func _on_button_deck_pressed() -> void:
	var menu_deck : MenuDeck = MENU_DECK.instantiate()
	add_child(menu_deck)
	menu_deck.move_to_front()
	menu_deck.sair_menu_deck = _fechar_menu_deck.bind(menu_deck)

func _fechar_menu_deck(menu_deck: MenuDeck) -> void:
	menu_deck.queue_free()
	_mostrar_deck()
