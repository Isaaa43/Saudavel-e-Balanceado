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

var buttons_selecionados_list : Array[Button] = []
var passiva_selecionada : Button = null

# TODO: solucao melhor
func add_log(txt : String) -> void:
	label_log.text += '\n' + txt 

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
	NetworkServer.iniciar_partida()

func _on_button_sair_pressed() -> void:
	TrocaCenaTemp.go_to_menu_inicial()
