extends Control
class_name MenuPartida

# TODO: remover isso
@export var debug_ignorar_checks := true

@export var qntd_magias_grimorio : int = 4

@onready var grid_container: GridContainer = $VBoxMagias/GridContainer
@onready var h_box_container: HBoxContainer = $VBoxMagias/HBoxContainer
@onready var button_comecar: Button = $VBoxPartida/ButtonComecar
@onready var button_sair: Button = $VBoxPartida/ButtonSair

@onready var label_log: Label = $VBoxContainer/LabelLog

@onready var grid_deck: GridContainer = $Deck/ScrollContainer/GridDeck
@onready var img_card_ref: TextureRect = $Deck/ScrollContainer/ImgCardRef


var buttons_selecionados_list : Array[Button] = []
var passiva_selecionada : Button = null

# TODO: solucao melhor
# TODO: Criar autoload para manter o log das acoes de rede
func add_log(txt : String) -> void:
	label_log.text += '\n' + txt 

func _ready() -> void:
	# TODO:
	button_comecar.grab_focus()
	
	# TODO: mudar isso
	Network.logs.update_conexao_texto.connect(add_log)
	
	_mostrar_deck()
	
	# pego os botoes da grid
	for button : Button in grid_container.get_children().filter(func(a): return a is Button):
		button.pressed.connect(clicado.bind(button))
	#
	for button : Button in h_box_container.get_children().filter(func(a): return a is Button):
		button.pressed.connect(passiva_select.bind(button))
	# 
	verificar_partida_comecar()


func _mostrar_deck() -> void:
	for c in grid_deck.get_children():
		c.queue_free()
	
	# adiciona as imagens das cartas
	for card: MenuDeck.CardData in GlobalDeck.cards_escolhidos:
		var img := img_card_ref.duplicate()
		img.texture = card.icone
		grid_deck.add_child(img)
		img.show()

func verificar_partida_comecar() -> void:
	# TODO: Por enquato vai isso, mas no futuro fazer um sistema de voto, tipo ready DBD
	# somente o server pode iniciar a partida
	button_comecar.disabled = not multiplayer.is_server()
	return
	
	# TODO: remover
	if debug_ignorar_checks: 
		button_comecar.disabled = false 
		return
	
	var condicao_comecar : bool = buttons_selecionados_list.size() == qntd_magias_grimorio
	condicao_comecar = condicao_comecar and (passiva_selecionada != null)
	button_comecar.disabled = not condicao_comecar

func clicado(button : Button):
	# ja tem -> tira da lista
	if buttons_selecionados_list.has(button):
		button.flat = false
		buttons_selecionados_list.erase(button)
		verificar_partida_comecar()
		return
	# add na lista
	buttons_selecionados_list.append(button)
	button.flat = true
	# se tiver mts na lista -> tira o ultimo
	if buttons_selecionados_list.size() > qntd_magias_grimorio:
		clicado(buttons_selecionados_list[0])
	
	verificar_partida_comecar()

func passiva_select(button : Button) -> void:
	# desativa o anterior, se tiver
	if passiva_selecionada != null:
		passiva_selecionada.flat = false
	# seleciona o atual
	passiva_selecionada = button
	passiva_selecionada.flat = true
	
	verificar_partida_comecar()

func _on_button_comecar_pressed() -> void:
	if not is_multiplayer_authority(): return
	Network.server.iniciar_partida()

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
