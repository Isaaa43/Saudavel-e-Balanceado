extends Control
class_name MenuPartida

@onready var label_jog_prontos: Label = %LabelJogProntos
@onready var label_ajustando_inicio: Label = %LabelAjustandoInicio
@onready var button_comecar: Button = $%ButtonComecar
@onready var label_button_comecar: Label = %LabelButtonComecar
@onready var label_ajuste_grimorio: Label = %LabelAjusteGrimorio

@onready var display_grimorio: DisplayGrimorio = $DisplayGrimorio

@onready var label_log: Label = $VBoxLogs/LabelLog

@onready var button_sair: Button = $%ButtonVoltar

var votos_partida_por_peer_id : Dictionary[int, bool] = {}

func _ready() -> void:
	# esconde labels
	label_ajustando_inicio.hide()
	label_ajuste_grimorio.hide()
	# 
	button_comecar.grab_focus()
	
	# atualiza o botao comecar
	atualizar_botao_comecar_partida()
	display_grimorio.grimorio_atualizado.connect(atualizar_botao_comecar_partida)
	
	# atualiza os logs da conexao visualmente
	Network.logs.update_conexao.connect(_update_logs)
	_update_logs()
	
	# servidor contabilizar os votos
	Network.server.jogador_votou_iniciar_partida.connect(_receber_voto)
	# atualiza os votos para iniciar partida
	Network.client.ajustar_votos_iniciar_partida.connect(_update_votos)
	_update_votos()

# Votar Comecar Partida
# -----------------------------------------------------------------------------

func atualizar_botao_comecar_partida() -> void:
	# verifica se o jogador nao precisa de algo antes de comecar a partida
	var invalido: bool = GlobalDeck.deck_size != GlobalDeck.get_deck().size()
	# libera o botao somente se valido
	button_comecar.disabled = invalido
	label_ajuste_grimorio.visible = invalido

func _on_button_comecar_toggled(toggled_on: bool) -> void:
	Network.client.votar_iniciar_partida(toggled_on)
	# altera o texto de acordo se deu ready ou nao
	if toggled_on:
		# se deu ready
		label_button_comecar.text = "Retirar Pronto"
	else:
		# sem ready
		label_button_comecar.text = "Pronto para Começar"

func _update_votos(qtde_votos: int = 0) -> void:
	label_jog_prontos.text = "Jogadores prontos:\n %d / %d" % [qtde_votos, 2]

# SERVIDOR: Lidar com os votos da Partida
# -----------------------------------------------------------------------------

var esta_cooldown_transmissao_voto: bool = false

func _receber_voto(peer_id_jog: int, voto: bool) -> void:
	if not multiplayer.is_server(): return
	
	# atualiza o voto desse jogador
	votos_partida_por_peer_id[peer_id_jog] = voto
	# verifica se tem todos os votos
	var qtde_votos: int = _contar_votos_iniciar_partida()
	
	# verifica se pode iniciar a partida
	if _verificar_votos_necessarios():
		get_tree().create_timer(2.0).timeout.connect(_tentar_iniciar_partida)
		label_ajustando_inicio.show()
		# TODO: quick fix para nao ficar 1/2 votos e iniciar
		_update_votos(2)
	
	# se estiver no cooldown, nao transmita 
	if esta_cooldown_transmissao_voto: return
	# transmita para todos os jogadores a quantidade de votos
	Network.server.transmitir_votos_partida(qtde_votos)
	# entre no cooldown
	esta_cooldown_transmissao_voto = true
	# sair do cooldown dps de um tempo
	get_tree().create_timer(1.0).timeout.connect(
		func(): esta_cooldown_transmissao_voto = false )

func _contar_votos_iniciar_partida() -> int:
	var qtde_votos: int = 0
	for voto:bool in votos_partida_por_peer_id.values():
		if voto: qtde_votos += 1
	return qtde_votos

func _verificar_votos_necessarios() -> bool:
	var qtde_votos: int = _contar_votos_iniciar_partida()
	return qtde_votos == 2

func _tentar_iniciar_partida() -> void:
	if not multiplayer.is_server(): return
	
	label_ajustando_inicio.hide()
	
	if _verificar_votos_necessarios():
		Network.server.iniciar_partida()

# Sair
# -----------------------------------------------------------------------------

func _on_button_sair_pressed() -> void:
	TrocaCenaTemp.go_to_menu_inicial()

# Logs de Conexao
# -----------------------------------------------------------------------------

func _update_logs() -> void:
	label_log.text = Network.logs.get_recent_logs_string()
