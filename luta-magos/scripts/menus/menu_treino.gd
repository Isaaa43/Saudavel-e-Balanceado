class_name MenuTreino
extends Control

@onready var button_comecar: Button = $%ButtonComecar
@onready var label_ajuste_grimorio: Label = %LabelAjusteGrimorio
@onready var display_grimorio: DisplayGrimorio = $DisplayGrimorio

func _ready() -> void:
	button_comecar.grab_focus()
	label_ajuste_grimorio.hide()
	_verificar_comecar()
	display_grimorio.grimorio_atualizado.connect(_verificar_comecar)

func _verificar_comecar() -> void:
	var invalido: bool = GlobalDeck.treino_deck_size < GlobalDeck.get_deck().size()

	# libera o botao somente se valido
	button_comecar.disabled = invalido
	label_ajuste_grimorio.visible = invalido

func _on_button_comecar_pressed() -> void:
	TrocaCenaTemp.go_to_treino()

func _on_button_sair_pressed() -> void:
	TrocaCenaTemp.go_to_menu_inicial()
