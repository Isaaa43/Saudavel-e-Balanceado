# GlobalDeck
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

#func get_feiticos_def() -> Array[FeiticoDef]:
	#var lista_feiticos_def: Array[FeiticoDef] = []
	## transforma os feiticos_id em feiticos_def do deck atual
	#for feitico_id: String in feiticos_id_escolhidos:
		#var feitico_def: FeiticoDef = Registros.reg_feiticos.get_feitico(feitico_id)
		#lista_feiticos_def.append(feitico_def)
	#return lista_feiticos_def

func calc_add_idx(idx: int, qnt: int) -> int:
	var qtd_feiticos_deck: int = feiticos_id_escolhidos.size()
	
	idx = idx + qnt
	
	# ciclico
	if idx > qtd_feiticos_deck-1: 
		idx = 0
	if idx < 0:
		idx = qtd_feiticos_deck-1
	
	idx = min(idx, qtd_feiticos_deck-1)
	idx = max(idx, 0)
	return idx
