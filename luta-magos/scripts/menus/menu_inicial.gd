extends Control

@onready var ui: PanelContainer = $UI
@onready var panel_jogar: Panel = $PanelJogar

func _on_button_sair_jogo_pressed() -> void:
	get_tree().quit()

func  _ready() -> void:
	panel_jogar.hide()

func _on_button_jogar_pressed() -> void:
	panel_jogar.show()
	ui.hide()

func _on_button_cancelar_pressed() -> void:
	panel_jogar.hide()
	ui.show()

func _on_button_host_pressed() -> void:
	TrocaCenaTemp.Network.create_server()
	#TrocaCenaTemp.go_to_menu_partida()
	TrocaCenaTemp.go_to_game()
	

func _on_button_join_pressed() -> void:
	TrocaCenaTemp.Network.create_client()
	#TrocaCenaTemp.go_to_menu_partida()
	TrocaCenaTemp.go_to_game()
