extends Node

@export var mana_regen: float = 1.5
@export var deck_size: int = 3

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
