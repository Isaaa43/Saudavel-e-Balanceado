extends Control

@export var focus_inicial: Control

@onready var ui: PanelContainer = $UI
@onready var panel_jogar: Panel = $PanelJogar
@onready var line_edit_nome_jogador: LineEdit = $UI/VBoxContainer/LineEditNomeJogador
@onready var button_join: Button = $PanelJogar/Control/Margin/VBoxContainer/HBoxContainer/ButtonJoin

func _on_button_sair_jogo_pressed() -> void:
	get_tree().quit()

func _debug_auto_multiplas_inst() -> void:
	if not TrocaCenaTemp.jogo_iniciado:
		var args = OS.get_cmdline_args()
		print("args:")
		print(args)		
		for arg in args:
			if arg.begins_with("-host") or arg.begins_with("-server"):
				await get_tree().create_timer(0.1).timeout
				Network.client.dados_jogador.nome = "Hosterson"
				_on_button_host_pressed()
			if arg.begins_with("-join") or arg.begins_with("-client"):
				await get_tree().create_timer(0.1).timeout
				Network.client.dados_jogador.nome = "Joiner"
				_on_button_join_pressed()

func  _ready() -> void:
	# TODO: REMOVER
	_debug_auto_multiplas_inst()
	
	panel_jogar.hide()
	# TODO: criar loading
	Network.client_connection_failed.connect(_habilitar_button_join.bind(true))
	# TODO: 
	focus_inicial.grab_focus()


func _on_button_jogar_pressed() -> void:
	panel_jogar.show()
	ui.hide()
	# TODO:
	button_join.grab_focus()
	# pegar nome
	var nome_jog := line_edit_nome_jogador.text
	if nome_jog.length() < 2:
		nome_jog = "Jog_" + str(randi_range(1000, 9999))
	print("nome_jog ", nome_jog)
	Network.client.dados_jogador.nome = nome_jog

func _on_button_cancelar_pressed() -> void:
	panel_jogar.hide()
	ui.show()

func _on_button_host_pressed() -> void:
	Network.server.criar_lobby()

func _on_button_join_pressed() -> void:
	Network.client.entrar_lobby()
	# TODO: criar loading
	_habilitar_button_join(false)

# TODO: criar loading
func _habilitar_button_join(habilitar: bool) -> void:
	button_join.disabled = not habilitar
	if button_join.disabled:
		button_join.text = "Conectando"
	else:
		button_join.text = "Join"
