class_name MenuDeck
extends Control

@export var lista_feiticos_res: ListaFeiticosRes
## Lista com os todos os feiticos
var lista_feiticos: Array[FeiticoDef]

# Lista de cartas que aparecem na coluna do meio.
var available_cards: Array[CardData] = []

## Quantidade máxima de cartas permitida no deck do jogador.
@export var max_deck_size: int = 3
## Carta clicavel dos feiticos
@export var card_button_scene: PackedScene

#
@export_group("Lista Grimorios Salvos")
@export var lista_grimorios_salvos : Array[GrimorioPresetRes] = []


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

@onready var deck_count_label: Label = %DeckCountLabel
@onready var add_button: Button = %AddButton
@onready var remove_button: Button = %RemoveButton
@onready var clear_button: Button = %ClearButton

@onready var grimorios_list: ItemList = %GrimoriosList

@onready var buttonVoltar: Button = %ButtonVoltar

@onready var popup_panel_feitico_dano: PopupPanel = $PopupPanelFeiticoDano
@onready var popup_panel_poucos_feiticos: PopupPanel = $PopupPanelPoucosFeiticos

var sair_menu_deck : Callable = TrocaCenaTemp.go_to_menu_inicial

func _ready() -> void:
	# TODO: melhorar
	max_deck_size = GlobalDeck.deck_size
	lista_feiticos = lista_feiticos_res.lista_feiticos
	
	popup_panel_feitico_dano.hide()
	popup_panel_poucos_feiticos.hide()
	
	deck_list.item_selected.connect(_on_deck_list_item_selected)

	add_button.pressed.connect(_on_add_button_pressed)
	remove_button.pressed.connect(_on_remove_button_pressed)
	clear_button.pressed.connect(_on_clear_button_pressed)
	
	_create_cards_from_spells()
	
	# carrega os grimorios salvos
	_load_grimorios_salvos()
	# carrega o deck
	_load_deck()
	
	_populate_card_pool()
	_update_deck_list()
	_clear_card_info()

func _load_deck() -> void:
	for card: CardData in GlobalDeck.get_deck():
		# Adiciona a carta ao array do deck.
		deck_cards.append(card)

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
		var text := "%s  | %d mana" % [card.nome, card.custo]
		deck_list.add_item(text, card.icone)

	# Atualiza o contador de cartas do deck.
	deck_count_label.text = "Feitiços no grimório: %d / %d" % [
		deck_cards.size(),
		max_deck_size
	]
	GlobalDeck.set_deck(deck_cards)

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

	# verifica se n foi adicionada ja (nao pode repetir)
	for _card: CardData in deck_cards:
		if _card.feitico_id == card.feitico_id:
			print("Carta já adicionada")
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
	
	# muda para o grimorio personalizado
	_set_grimorio_atual()

func _on_clear_button_pressed() -> void:
	_clear_deck()
	
	# muda para o grimorio personalizado
	_set_grimorio_atual()

func _clear_deck() -> void:
	# limpa a lista de cartas
	deck_cards.clear()
	# Reseta o índice selecionado
	selected_deck_index = -1
	# Atualiza a lista visual do deck.
	_update_deck_list()

# Grimorios Salvos
# -----------------------------------------------------------------------------

func _load_grimorios_salvos() -> void:
	grimorios_list.clear()
	# popula a lista
	for grimorio_preset : GrimorioPresetRes in lista_grimorios_salvos:
		grimorios_list.add_item(grimorio_preset.nome_grimorio)
	# inicia com o personalizado selecionado
	grimorios_list.select(0)

var grimorio_index_last: int = 0

func _on_grimorios_list_item_selected(index: int) -> void:
	# se estava no personalizado antes
	if grimorio_index_last == 0:
		_save_grimorio_atual(deck_cards)
	# muda para o grimorio selecionado
	var grimorio : GrimorioPresetRes = lista_grimorios_salvos.get(index)
	_carregar_deck_salvo(grimorio)
	# atualiza para o selecionado atual
	grimorio_index_last = index

func _carregar_deck_salvo(grimorio : GrimorioPresetRes) -> void:
	# limpa o deck
	_clear_deck()
	# usa as cartas (nao a lista de feiticos def)
	if grimorio.usar_card_data:
		for card : CardData in grimorio.lista_cards:
			_add_card_to_deck(card)
		return 
	# pega as cartas referentes ao feiticos def do grimorio
	for feitico_def : FeiticoDef in grimorio.feiticos:
		var card: CardData = _find_card_from_feitico(feitico_def)
		if card:
			_add_card_to_deck(card)

func _find_card_from_feitico(feitico_def: FeiticoDef) -> CardData:
	for card : CardData in available_cards:
		if card.feitico_id == feitico_def.feitico_id:
			return card
	return null

func _set_grimorio_atual() -> void:
	_save_grimorio_atual(deck_cards)
	# seleciona o personalizado
	grimorios_list.select(0)

func _save_grimorio_atual(_deck_cards: Array[CardData]) -> void:
	# pega o personalizado
	var grimorio_personalizado : GrimorioPresetRes = lista_grimorios_salvos[0]
	# salva as cartas do _deck_cards
	grimorio_personalizado.lista_cards = _deck_cards.duplicate()

# Sair da partida
# -----------------------------------------------------------------------------

func _verificar_tem_dano() -> bool:
	for card: CardData in deck_cards:
		if card.espaco == Feitico.Espaco.DANO:
			return true
	return false

## verificar se cartas no deck para preencher o grimorio, ou seja, sem espacos vazios
## [br] Retorna [code]True[/code] caso tenha cartas no deck igual o tamanho max do deck
## [br] Retorna [code]False[/code] caso [b]falte (ou passe)[/b] 
## o numero de cartas do deck do tamanho max do deck
func _verificar_grimorio_cheio() -> bool:
	# quantidade de cartas necessarias
	# minimo tamanho maximo do deck, e quantidade de cartas total disponiveis
	# para caso o maximo do deck seja mil (para teste), ou tenha poucas cartas
	var qtd_cartas_necessarias = min(max_deck_size, lista_feiticos.size())
	return deck_cards.size() == qtd_cartas_necessarias

func mostrar_popup(popup: PopupPanel) -> void:
	popup.popup_centered()
	await get_tree().create_timer(4.0).timeout
	popup.hide()

func _on_button_voltar_pressed() -> void:
	if not _verificar_tem_dano():
		mostrar_popup(popup_panel_feitico_dano)
	elif not _verificar_grimorio_cheio():
		mostrar_popup(popup_panel_poucos_feiticos)
	else:
		sair_menu_deck.call()

# =============================================================================
# Card Data
# =============================================================================
class CardData:
	extends RefCounted
	
	var feitico_id: String
	## Texto com o nome da carta
	var nome: String
	## Tipo da carta
	var tipo: String
	## Espaco que a carta ocupa (Dano, Suporte, Revelacao)
	var espaco: Feitico.Espaco
	## Texto descritivo da carta.
	var descricao: String
	## Custo de mana para ativar a carta
	var custo: int
	## imagem da carta exibida na interface.
	var icone: Texture2D
	
	func _init(feitico_def: FeiticoDef) -> void:
		feitico_id 	= feitico_def.feitico_id
		nome 		= feitico_def.nome
		tipo 		= _feitico_tipo_para_string(feitico_def.tipo)
		espaco 		= feitico_def.espaco
		descricao 	= _formatar_descricao(feitico_def)
		custo 		= int(feitico_def.custo)
		icone 		= feitico_def.icone_hud
	
	func _formatar_descricao(feitico_def: FeiticoDef) -> String:
		var descricao_raw: String = feitico_def.descricao
		var valor: float = 0.0
		
		# -- pega o valor
		# obtem o comportamento def
		if not feitico_def.comportamento_def: return descricao_raw
		var comportamento_def : FeiticoComportamentoDef = feitico_def.comportamento_def
		
		# TODO: trocar isso para cada comportamento ter uma funcao de formatar o texto
		
		
		# TODO : aaaaaaaaaa
		if comportamento_def is FeiticoComportamentoArmadilhaDef:
			comportamento_def = comportamento_def.comportamento_ativacao_def
		
		# obtem a lista de efeitos
		if not comportamento_def.lista_efeitos: return descricao_raw
		var lista_efeitos: Array = comportamento_def.lista_efeitos
		if lista_efeitos.is_empty(): return descricao_raw
		# obtem o primeiro efeito
		var efeito_def : FeiticoEfeitoDef = lista_efeitos.get(0)
		# obtem o valor
		valor = efeito_def.valor
		
		# TODO: algo melhor do q isso para a revelacao em area
		if comportamento_def is FeiticoComportamentoProjetilDef:
			if comportamento_def.velocidade == 0.0:
				valor =  comportamento_def.tamanho_raio
		
		# -- retorna o texto formatado
		return descricao_raw.format({"valor": int(valor)})
	
	func _feitico_tipo_para_string(_tipo: Feitico.Tipo) -> String:
		match (_tipo):
			Feitico.Tipo.PROJETIL:
				return "Projetil"
			Feitico.Tipo.POSICIONADO:
				return "Posicionado"
			Feitico.Tipo.EFEITO:
				return "Efeito"
		# caso de erro, retorne essa opcao para podermos diagnosticar
		return "Feitico.Tipo_" + str(_tipo)
	#
	#func _feitico_espaco_para_string(_espaco: Feitico.Espaco) -> String:
		#match (_espaco):
			#Feitico.Espaco.DANO:
				#return "Dano"
			#Feitico.Espaco.SUPORTE:
				#return "Suporte"
			#Feitico.Espaco.REVELACAO:
				#return "Revelacao"
		## caso de erro, retorne essa opcao para podermos diagnosticar
		#return "Feitico.Espaco_" + str(_espaco)
