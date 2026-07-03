extends Node

@export var mana_regen: float = 3
@export var deck_size: int = 4

@onready var treino_mana_regen: float = mana_regen
@onready var treino_deck_size: int = deck_size

@export var feiticos_id_escolhidos: Array[String]
var cards_escolhidos: Array[MenuDeck.CardData]

func set_deck(deck_cards: Array[MenuDeck.CardData]) -> void:
	feiticos_id_escolhidos.clear()
	cards_escolhidos.clear()
	
	for card: MenuDeck.CardData in deck_cards:
		feiticos_id_escolhidos.append(card.feitico_id)
		cards_escolhidos.append(card)

func get_deck() -> Array[MenuDeck.CardData]:
	return cards_escolhidos
