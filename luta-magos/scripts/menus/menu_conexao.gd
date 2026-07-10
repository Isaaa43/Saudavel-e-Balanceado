class_name MenuConexao
extends Control

@export var foco_inicial: Control

@onready var button_host: Button = %ButtonHost
@onready var button_join: Button = %ButtonJoin

@onready var texture_host: TextureRect = $Top/HBox/ButtonHost/TextureRect
@onready var texture_join: TextureRect = $Top/HBox/ButtonJoin/TextureRect

@export var cor_pressed_host: Color
@export var cor_pressed_join: Color
@onready var cor_normal_host: Color = texture_host.self_modulate
@onready var cor_normal_join: Color = texture_join.self_modulate


@onready var line_edit_nome_jogador: LineEdit = $%LineEditNomeJogador
@onready var line_edit_ip: LineEdit = $%LineEditIp
@onready var button_conexao_jogar: Button = %ButtonConexaoJogar

@onready var mid: Control = $Mid
@onready var h_box_ip: HBoxContainer = $Mid/HBoxIP

@onready var label_conectando: RichTextLabel = $LabelConectando
@onready var popup_falha: PopupPanel = $PopupFalha


func _on_button_voltar_pressed() -> void:
	TrocaCenaTemp.go_to_menu_inicial()

func  _ready() -> void:
	# conexao do join falhou
	Network.client_connection_failed.connect(_failed_join)
	#
	_mostrar_inicio()

func _mostrar_inicio() -> void:
	line_edit_ip.text = Network.get_ip()
	if Network.client.dados_jogador.nome.length() > 1:
		line_edit_nome_jogador.text = Network.client.dados_jogador.nome
	_verificar_conexao_ready()
	# esconde o meio ate selecionar o host ou join
	mid.hide()
	# desliga o loading se tiver
	_tela_loading(false)
	#
	label_conectando.hide()
	popup_falha.hide()


# Conexao
# -----------------------------------------------------------------------------

# -- Jogador vai dar host ou join --

## True se o jogador for o host
var is_host: bool = false

func _on_button_host_toggled(toggled_on: bool) -> void:
	# desabilita o toggle off
	if not toggled_on: 
		button_host.set_pressed_no_signal(true)
		return
	# marca como host
	var _is_host_pressed: bool = true
	_conexao_pressed(_is_host_pressed)

func _on_button_join_toggled(toggled_on: bool) -> void:
	# desabilita o toggle off
	if not toggled_on: 
		button_join.set_pressed_no_signal(true)
		return
	# marca como join
	var _is_host_pressed: bool = false
	_conexao_pressed(_is_host_pressed)

func _conexao_pressed(host_pressed: bool) -> void:
	if host_pressed: # Host
		is_host = true
		button_host.set_pressed_no_signal(true)
		button_join.set_pressed_no_signal(false)
		texture_host.self_modulate = cor_pressed_host
		texture_join.self_modulate = cor_normal_join
	else: # Join
		is_host = false
		button_host.set_pressed_no_signal(false)
		button_join.set_pressed_no_signal(true)
		texture_host.self_modulate = cor_normal_host
		texture_join.self_modulate = cor_pressed_join
	_verificar_conexao_ready()
	# mostrar meio
	# mostra o ip somente se for o join
	h_box_ip.visible = not is_host
	mid.show()

# -- verifica o nome do jogador --

func _on_line_edit_nome_jogador_text_changed(_new_text: String) -> void:
	_verificar_conexao_ready()
func _on_line_edit_nome_jogador_editing_toggled(_toggled_on: bool) -> void:
	_verificar_conexao_ready()

func _is_nome_valido() -> bool:
	var nome_jog := line_edit_nome_jogador.text
	return nome_jog.length() > 2

## Verifica se tem as condicoes necessarias para comecar a conexao
func _verificar_conexao_ready() -> void:
	var valido: bool = (
		(button_host.button_pressed or button_join.button_pressed)
		and _is_nome_valido()
	)
	button_conexao_jogar.disabled = not valido

## Ao apertar para comecar a conexao
func _on_button_conexao_jogar_pressed() -> void:
	if not _is_nome_valido(): 
		button_conexao_jogar.disabled = true
		return 
	
	_pegar_nome_jogador()
	# 
	if is_host:
		_comecar_host()
	else:
		_comecar_join()

func _pegar_nome_jogador() -> void:
	# pegar nome
	var nome_jog := line_edit_nome_jogador.text
	Network.client.dados_jogador.nome = nome_jog

func _comecar_host() -> void:
	Network.server.criar_lobby()

func _comecar_join() -> void:
	var ip_adress : String = line_edit_ip.text
	Network.IP_ADDR = ip_adress
	# entre no lobby
	Network.client.entrar_lobby()
	_tela_loading(true)
	# TODO: criar loading
	button_host.hide()
	button_join.hide()
	button_conexao_jogar.hide()

# -----------------------------------------------------------------------------
func _tela_loading(esta_carregando: bool = true) -> void:
	# esconde coisas se esta carregando
	button_host.visible = not esta_carregando
	button_join.visible = not esta_carregando
	button_conexao_jogar.visible = not esta_carregando
	# nao deixa editar se esta carregando
	line_edit_ip.editable = not esta_carregando
	line_edit_nome_jogador.editable = not esta_carregando
	# mostra o texto se estiver carregando
	label_conectando.visible = esta_carregando

# -----------------------------------------------------------------------------
func _failed_join() -> void:
	popup_falha.popup_centered()
	await get_tree().create_timer(5.5).timeout
	popup_falha.hide()
	# mostrar tela de novo
	_mostrar_inicio()
