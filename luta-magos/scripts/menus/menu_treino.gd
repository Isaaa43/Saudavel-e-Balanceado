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
	pass

func _on_button_sair_pressed() -> void:
	TrocaCenaTemp.go_to_menu_inicial()

const MENU_DECK = preload("uid://djncp32jv7ppr")
func _on_button_deck_pressed() -> void:
	var menu_deck : MenuDeck = MENU_DECK.instantiate()
	add_child(menu_deck)
	menu_deck.move_to_front()
	menu_deck.buttonVoltar.disconnect("pressed", menu_deck._on_button_pressed)
	menu_deck.buttonVoltar.pressed.connect(_fechar_menu_deck.bind(menu_deck) )

func _fechar_menu_deck(menu_deck: MenuDeck) -> void:
	if menu_deck._verificar_tem_dano():
		menu_deck.queue_free()
		_mostrar_deck()
	else:
		menu_deck.popup_feitico_dano()


# HACKS ----------------------------------------------------
func _on_spin_box_mana_value_changed(value: float) -> void:
	GlobalDeck.mana_regen = value

func _on_spin_box_cartas_deck_value_changed(value: float) -> void:
	GlobalDeck.deck_size = int(value)
