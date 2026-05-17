extends Control

@export var available_cards: Array[CardData] = []
@export var max_deck_size: int = 20

var deck_cards: Array[CardData] = []
var selected_card: CardData = null
var selected_deck_index: int = -1


@onready var card_pool: ItemList = %CardPool
@onready var deck_list: ItemList = %DeckList

@onready var card_art: TextureRect = %CardArt
@onready var card_name: Label = %CardName
@onready var card_type_cost: Label = %CardTypeCost
@onready var card_description: RichTextLabel = %CardDescription

@onready var add_button: Button = %AddButton
@onready var remove_button: Button = %RemoveButton
@onready var deck_count_label: Label = %DeckCountLabel


func _ready() -> void:
	card_pool.item_selected.connect(_on_card_pool_item_selected)
	card_pool.item_activated.connect(_on_card_pool_item_activated)

	deck_list.item_selected.connect(_on_deck_list_item_selected)

	add_button.pressed.connect(_on_add_button_pressed)
	remove_button.pressed.connect(_on_remove_button_pressed)

	_populate_card_pool()
	_update_deck_list()
	_clear_card_info()


func _populate_card_pool() -> void:
	card_pool.clear()

	for card in available_cards:
		var text := "%s  |  Custo: %d" % [card.nome, card.custo]

		if card.icone:
			card_pool.add_item(text, card.icone)
		else:
			card_pool.add_item(text)


func _update_deck_list() -> void:
	deck_list.clear()

	for card in deck_cards:
		var text := "%s  |  Custo: %d" % [card.nome, card.custo]
		deck_list.add_item(text)

	deck_count_label.text = "Cartas no deck: %d / %d" % [
		deck_cards.size(),
		max_deck_size
	]


func _show_card_info(card: CardData) -> void:
	selected_card = card

	card_name.text = card.nome
	card_type_cost.text = "%s | Custo: %d" % [card.tipo, card.custo]
	card_description.text = card.descricao

	if card.icone:
		card_art.texture = card.icone
	else:
		card_art.texture = null


func _clear_card_info() -> void:
	selected_card = null
	card_name.text = "Nenhuma carta selecionada"
	card_type_cost.text = ""
	card_description.text = "Selecione uma carta para ver os detalhes."
	card_art.texture = null


func _on_card_pool_item_selected(index: int) -> void:
	var card := available_cards[index]
	_show_card_info(card)


func _on_card_pool_item_activated(index: int) -> void:
	var card := available_cards[index]
	_show_card_info(card)
	_add_card_to_deck(card)


func _on_deck_list_item_selected(index: int) -> void:
	selected_deck_index = index

	var card := deck_cards[index]
	_show_card_info(card)


func _on_add_button_pressed() -> void:
	if selected_card == null:
		return

	_add_card_to_deck(selected_card)


func _add_card_to_deck(card: CardData) -> void:
	if deck_cards.size() >= max_deck_size:
		print("Deck cheio!")
		return

	deck_cards.append(card)
	_update_deck_list()


func _on_remove_button_pressed() -> void:
	if selected_deck_index < 0:
		return

	if selected_deck_index >= deck_cards.size():
		return

	deck_cards.remove_at(selected_deck_index)
	selected_deck_index = -1
	_update_deck_list()
