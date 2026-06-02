class_name MenuDeck
extends Control

# TODO: trocar para algo automatico dps
## Essa lista é preenchida pelo Inspector da Godot, arrastando arquivos .tres dos Feiticos.
@export var lista_feiticos: Array[FeiticoDef] = []

# Lista de cartas que aparecem na coluna do meio.
var available_cards: Array[CardData] = []

# Quantidade máxima de cartas permitida no deck do jogador.
@export var max_deck_size: int = 3
@export var card_button_scene: PackedScene

# Lista de cartas que o jogador adicionou ao deck durante a montagem.
# Essa lista existe apenas em tempo de execução.
var deck_cards: Array[CardData] = []

# Guarda a carta atualmente selecionada, seja na lista de cartas disponíveis
# ou na lista do deck.
var selected_card: CardData = null

# Guarda o índice da carta selecionada dentro do deck.
# Começa em -1 porque, inicialmente, nenhuma carta do deck está selecionada.
var selected_deck_index: int = -1


# Referências aos nós da interface.
# O símbolo % funciona porque esses nós foram marcados como "Acessar como Nome Único".
@onready var card_grid: GridContainer = %CardGrid
@onready var deck_list: ItemList = %DeckList

@onready var card_art: TextureRect = %CardArt
@onready var card_name: Label = %CardName
@onready var card_type_cost: Label = %CardTypeCost
@onready var card_description: RichTextLabel = %CardDescription

@onready var add_button: Button = %AddButton
@onready var remove_button: Button = %RemoveButton
@onready var deck_count_label: Label = %DeckCountLabel


func _ready() -> void:
	deck_list.item_selected.connect(_on_deck_list_item_selected)

	add_button.pressed.connect(_on_add_button_pressed)
	remove_button.pressed.connect(_on_remove_button_pressed)
	
	_create_cards_from_spells()
	
	_populate_card_pool()
	_update_deck_list()
	_clear_card_info()

func _create_cards_from_spells() -> void:
	var qtd_feiticos := lista_feiticos.size()
	# cria o espaco para cada carta (mais rapido que append)
	available_cards.resize(qtd_feiticos)
	# para cada feitico def crie um CardData
	for i in range(qtd_feiticos):
		var feitico_def: FeiticoDef = lista_feiticos[i]
		available_cards[i] = CardData.new(feitico_def)

func _populate_card_pool() -> void:
	for child in card_grid.get_children():
		child.queue_free()

	if card_button_scene == null:
		push_error("Card button scene não foi definida no Inspector.")
		return

	for card in available_cards:
		var card_button := card_button_scene.instantiate() as CardGridItem

		card_grid.add_child(card_button)

		card_button.setup(card)
		card_button.card_selected.connect(_on_card_grid_item_selected)
		card_button.card_activated.connect(_on_card_grid_item_activated)


func _update_deck_list() -> void:
	# Limpa a lista visual do deck antes de redesenhá-la.
	deck_list.clear()

	# Adiciona na interface todas as cartas que estão no array deck_cards.
	for card in deck_cards:
		var text := "%s  |  Custo de mana: %d" % [card.nome, card.custo]
		deck_list.add_item(text)

	# Atualiza o contador de cartas do deck.
	deck_count_label.text = "Feitiços no grimório: %d / %d" % [
		deck_cards.size(),
		max_deck_size
	]


func _show_card_info(card: CardData) -> void:
	# Define a carta recebida como a carta atualmente selecionada.
	selected_card = card

	# Atualiza a coluna da direita com as informações da carta.
	card_name.text = card.nome
	card_type_cost.text = "%s | Custo de mana: %d" % [card.tipo, card.custo]
	card_description.text = card.descricao

	# Atualiza a imagem/ícone da carta.
	if card.icone:
		card_art.texture = card.icone
	else:
		card_art.texture = null


func _clear_card_info() -> void:
	# Limpa a seleção atual e coloca textos padrão na coluna de informações.
	selected_card = null

	card_name.text = "Nenhum feitiço selecionado"
	card_type_cost.text = ""
	card_description.text = "Selecione um feitiço para ver os detalhes."
	card_art.texture = null


func _on_card_grid_item_selected(card: CardData) -> void:
	_show_card_info(card)


func _on_card_grid_item_activated(card: CardData) -> void:
	_show_card_info(card)
	_add_card_to_deck(card)


func _on_deck_list_item_selected(index: int) -> void:
	# Guarda qual posição do deck foi selecionada.
	# Isso é usado depois pelo botão de remover.
	selected_deck_index = index

	# Mostra as informações da carta selecionada no deck.
	var card := deck_cards[index]
	_show_card_info(card)


func _on_add_button_pressed() -> void:
	# Se nenhuma carta estiver selecionada, o botão não faz nada.
	if selected_card == null:
		return

	# Adiciona ao deck a carta atualmente selecionada.
	_add_card_to_deck(selected_card)


func _add_card_to_deck(card: CardData) -> void:
	# Impede que o jogador ultrapasse o tamanho máximo permitido do deck.
	if deck_cards.size() >= max_deck_size:
		print("Grimório cheio!")
		return

	# Adiciona a carta ao array do deck.
	deck_cards.append(card)

	# Atualiza a lista visual do deck na coluna esquerda.
	_update_deck_list()


func _on_remove_button_pressed() -> void:
	# Se nenhuma carta do deck estiver selecionada, o botão não faz nada.
	if selected_deck_index < 0:
		return

	# Segurança extra para evitar erro caso o índice salvo não exista mais.
	if selected_deck_index >= deck_cards.size():
		return

	# Remove a carta selecionada do array do deck.
	deck_cards.remove_at(selected_deck_index)

	# Reseta o índice selecionado, porque a carta foi removida.
	selected_deck_index = -1

	# Atualiza a lista visual do deck.
	_update_deck_list()

# =============================================================================
# Card Data
# =============================================================================
class CardData:
	extends RefCounted

	## Texto com o nome da carta
	var nome: String
	## Tipo da carta
	var tipo: String
	## Espaco que a carta ocupa (Deck, Passiva)
	var espaco: String
	## Texto descritivo da carta.
	var descricao: String
	## Custo de mana para ativar a carta
	var custo: int
	## imagem da carta exibida na interface.
	var icone: Texture2D
	
	func _init(feitico_def: FeiticoDef) -> void:
		nome 		= feitico_def.nome
		tipo 		= _feitico_tipo_para_string(feitico_def.tipo)
		espaco 		= _feitico_espaco_para_string(feitico_def.espaco)
		descricao 	= _formatar_descricao(feitico_def.descricao)
		custo 		= int(feitico_def.custo)
		icone 		= feitico_def.icone_hud
	
	func _formatar_descricao(descricao_raw: String) -> String:
		return descricao_raw
	
	func _feitico_tipo_para_string(tipo: Feitico.Tipo) -> String:
		match (tipo):
			Feitico.Tipo.PROJETIL:
				return "projetil"
			Feitico.Tipo.POSICIONADO:
				return "posicionado"
			Feitico.Tipo.EFEITO:
				return "efeito"
		# caso de erro, retorne essa opcao para podermos diagnosticar
		return "Feitico.Tipo_" + str(tipo)
	
	func _feitico_espaco_para_string(espaco: Feitico.Espaco) -> String:
		match (espaco):
			Feitico.Espaco.DECK:
				return "deck"
			Feitico.Espaco.PASSIVA:
				return "passiva"
		# caso de erro, retorne essa opcao para podermos diagnosticar
		return "Feitico.Espaco_" + str(espaco)
