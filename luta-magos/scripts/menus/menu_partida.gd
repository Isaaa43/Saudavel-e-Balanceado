extends Control

@export var qntd_magias_grimorio : int = 4

@onready var grid_container: GridContainer = $VBoxContainer/GridContainer
@onready var h_box_container: HBoxContainer = $VBoxContainer/HBoxContainer
@onready var button_comecar: Button = $VBoxContainer/ButtonComecar
@onready var button_sair: Button = $VBoxContainer/ButtonSair

var buttons_selecionados_list : Array[Button] = []
var passiva_selecionada : Button = null

func _ready() -> void:
	# pego os botoes da grid
	for button : Button in grid_container.get_children().filter(func(a): return a is Button):
		button.pressed.connect(clicado.bind(button))
	#
	for button : Button in h_box_container.get_children().filter(func(a): return a is Button):
		button.pressed.connect(passiva_select.bind(button))
	# 
	verificar_partida_comecar()

func verificar_partida_comecar() -> void:
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

func _on_button_sair_pressed() -> void:
	TrocaCenaTemp.go_to_menu_inicial()
