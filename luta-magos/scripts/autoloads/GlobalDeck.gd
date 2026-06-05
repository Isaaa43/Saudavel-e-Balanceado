extends Node

@export var feiticos_id_escolhidos: Array[String]

func set_deck(deck_cards: Array[MenuDeck.CardData]) -> void:
	feiticos_id_escolhidos.clear()
	for card: MenuDeck.CardData in deck_cards:
		feiticos_id_escolhidos.append(card.feitico_id)
