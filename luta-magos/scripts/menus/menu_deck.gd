extends Control

# Lista de cartas que aparecem na coluna do meio.
# Essa lista é preenchida pelo Inspector da Godot, arrastando arquivos .tres do tipo CardData.
@export var available_cards: Array[CardData] = []

# Quantidade máxima de cartas permitida no deck do jogador.
@export var max_deck_size: int = 3


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
	# Conecta os sinais da lista de cartas disponíveis.
	# item_selected é chamado quando o jogador clica em uma carta.
	# item_activated é chamado quando o jogador ativa o item, normalmente com duplo clique ou Enter.
	card_pool.item_selected.connect(_on_card_pool_item_selected)
	card_pool.item_activated.connect(_on_card_pool_item_activated)

	# Conecta o sinal da lista do deck.
	deck_list.item_selected.connect(_on_deck_list_item_selected)

	# Conecta os botões da interface.
	add_button.pressed.connect(_on_add_button_pressed)
	remove_button.pressed.connect(_on_remove_button_pressed)

	# Inicializa a interface.
	_populate_card_pool()
	_update_deck_list()
	_clear_card_info()


func _populate_card_pool() -> void:
	# Limpa a lista antes de preenchê-la.
	# Isso evita duplicar itens caso a função seja chamada novamente.
	card_pool.clear()

	# Para cada carta disponível, cria um item visual no ItemList da coluna do meio.
	for card in available_cards:
		var text := "%s  |  Custo de mana: %d" % [card.nome, card.custo]

		# Se a carta tiver um ícone, ele aparece junto do nome.
		# Se não tiver, aparece apenas o texto.
		if card.icone:
			card_pool.add_item(text, card.icone)
		else:
			card_pool.add_item(text)


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


func _on_card_pool_item_selected(index: int) -> void:
	# Quando o jogador clica em uma carta disponível,
	# pegamos a carta correspondente no array available_cards.
	var card := available_cards[index]

	# Mostra as informações da carta na coluna da direita.
	_show_card_info(card)


func _on_card_pool_item_activated(index: int) -> void:
	# Quando o jogador ativa uma carta disponível, normalmente com duplo clique,
	# a carta é exibida na coluna da direita e adicionada ao deck.
	var card := available_cards[index]

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
