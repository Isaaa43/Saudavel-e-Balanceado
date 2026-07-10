extends Control

@export var focus_tela: Dictionary[Tela, Control]

@onready var tela_principal: PanelContainer = %TelaPrincipal
@onready var tela_escolher_jogo: Control = %TelaEscolherJogo

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
				#_comecar_host()
			if arg.begins_with("-join") or arg.begins_with("-client"):
				await get_tree().create_timer(0.1).timeout
				Network.client.dados_jogador.nome = "Joiner"
				#_comecar_join()

func  _ready() -> void:
	# TODO: REMOVER
	_debug_auto_multiplas_inst()
	
	_mostrar_tela(Tela.PRINCIPAL)

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
	_mostrar_tela(Tela.CONEXAO)

func _on_button_treino_pressed() -> void:
	TrocaCenaTemp.go_to_menu_treino()

func _on_button_tutorial_pressed() -> void:
	pass # Replace with function body.

# Troca de Telas
# -----------------------------------------------------------------------------

func _mostrar_tela(tela: Tela) -> void:
	tela_principal.hide()
	tela_escolher_jogo.hide()
	
	match (tela):
		Tela.PRINCIPAL:
			tela_principal.show()
		Tela.JOGO:
			tela_escolher_jogo.show()
		Tela.CONEXAO:
			TrocaCenaTemp.go_to_conexao()
	
	# pega o foco no item
	await get_tree().process_frame
	if focus_tela.has(tela):
		focus_tela[tela].grab_focus()
