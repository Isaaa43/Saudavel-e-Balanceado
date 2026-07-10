extends Control

@export var focus_tela: Dictionary[Tela, Control]

@export var panel_nome: Panel 
@export var panel_jogar: Panel 

@onready var tela_principal: PanelContainer = %TelaPrincipal
@onready var tela_escolher_jogo: Control = %TelaEscolherJogo

@onready var line_edit_nome_jogador: LineEdit = $PanelNome/Control/VBoxContainer/LineEditNomeJogador
@onready var button_nome: Button = $PanelNome/Control/VBoxContainer/ButtonNome

@onready var button_join: Button = $PanelJogar/Control/Margin/VBoxContainer/HBoxContainer/ButtonJoin
@onready var line_edit_ip: LineEdit = $PanelJogar/Control/Margin/VBoxContainer/HBoxIP/LineEditIp
@onready var line_edit_port: LineEdit = $PanelJogar/Control/Margin/VBoxContainer/HBoxPort/LineEditPort

enum Tela {PRINCIPAL, JOGO, CONEXAO}

func _debug_auto_multiplas_inst() -> void:
	if not TrocaCenaTemp.jogo_iniciado:
		var args = OS.get_cmdline_args()
		print("args:")
		print(args)		
		for arg in args:
			await get_tree().physics_frame
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
	
	_mostrar_tela(Tela.PRINCIPAL)
	
	# TODO: criar loading
	Network.client_connection_failed.connect(_habilitar_button_join.bind(true))


# Tela Principal
# -----------------------------------------------------------------------------

func _on_button_menu_jogar_pressed() -> void:
	_mostrar_tela(Tela.JOGO)

func _on_button_config_pressed() -> void:
	TrocaCenaTemp.go_to_config()

func _on_button_creditos_pressed() -> void:
	TrocaCenaTemp.go_to_creditos()

func _on_button_deck_pressed() -> void:
	TrocaCenaTemp.menu_deck()

func _on_button_sair_jogo_pressed() -> void:
	get_tree().quit()


# Tela Escolher Jogo
# -----------------------------------------------------------------------------

func _on_button_voltar_pressed() -> void:
	_mostrar_tela(Tela.PRINCIPAL)

func _on_button_jogar_pressed() -> void:
	panel_nome.show()
	#ui.hide()
	line_edit_nome_jogador.grab_focus()
	button_nome.disabled = line_edit_nome_jogador.text.length() < 2

func _on_button_treino_pressed() -> void:
	TrocaCenaTemp.go_to_menu_treino()

func _on_button_tutorial_pressed() -> void:
	pass # Replace with function body.


# Jogar
# -----------------------------------------------------------------------------


func _on_button_cancelar_pressed() -> void:
	TrocaCenaTemp.go_to_menu_inicial()

func _on_button_host_pressed() -> void:
	_pegar_dados_conexao()
	Network.server.criar_lobby()

func _on_button_join_pressed() -> void:
	_pegar_dados_conexao()
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


# Conexao
# -----------------------------------------------------------------------------
func _show_conectar() -> void:
	panel_jogar.show()
	panel_nome.hide()
	#ui.hide()
	#
	button_join.grab_focus()
	# 
	line_edit_ip.text = Network.get_ip()
	line_edit_port.text = str(Network.PORT)

func _pegar_dados_conexao() -> void:
	var ip : String = line_edit_ip.text
	var port : int = int(line_edit_port.text)
	Network.IP_ADDR = ip
	Network.PORT = port

func _on_button_nome_pressed() -> void:
	# pegar nome
	var nome_jog := line_edit_nome_jogador.text
	if nome_jog.length() < 2:
		nome_jog = "Jog_" + str(randi_range(1000, 9999))
	print("nome_jog ", nome_jog)
	Network.client.dados_jogador.nome = nome_jog
	# 
	_show_conectar()

func _on_line_edit_nome_jogador_text_changed(_new_text: String) -> void:
	button_nome.disabled = _new_text.length() < 2


func _mostrar_tela(tela: Tela) -> void:
	tela_principal.hide()
	tela_escolher_jogo.hide()
	
	panel_nome.hide()
	panel_jogar.hide()
	
	match (tela):
		Tela.PRINCIPAL:
			tela_principal.show()
		Tela.JOGO:
			tela_escolher_jogo.show()
		Tela.CONEXAO:
			pass
	
	# pega o foco no item
	await get_tree().process_frame
	focus_tela[tela].grab_focus()
