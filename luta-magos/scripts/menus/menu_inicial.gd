extends Control

@onready var ui: PanelContainer = $UI
@onready var panel_jogar: Panel = $PanelJogar
@onready var line_edit_nome_jogador: LineEdit = $UI/VBoxContainer/LineEditNomeJogador

func _on_button_sair_jogo_pressed() -> void:
	get_tree().quit()

func  _ready() -> void:
	panel_jogar.hide()

func _on_button_jogar_pressed() -> void:
	panel_jogar.show()
	ui.hide()
	# pegar nome
	var nome_jog := line_edit_nome_jogador.text
	if nome_jog.length() < 2:
		nome_jog = "Jog_" + str(randi_range(1000, 9999))
	print("nome_jog ", nome_jog)
	NetworkClient.dados_jogador.nome = nome_jog

func _on_button_cancelar_pressed() -> void:
	panel_jogar.hide()
	ui.show()

func _on_button_host_pressed() -> void:
	NetworkServer.criar_lobby()

func _on_button_join_pressed() -> void:
	NetworkClient.entrar_lobby()
