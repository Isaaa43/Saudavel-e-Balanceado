class_name MenuTreino
extends Control

@onready var button_comecar: Button = $VBoxPartida/ButtonComecar

func _ready() -> void:
	button_comecar.grab_focus()

func _on_button_comecar_pressed() -> void:
	TrocaCenaTemp.go_to_treino()

func _on_button_sair_pressed() -> void:
	TrocaCenaTemp.go_to_menu_inicial()
