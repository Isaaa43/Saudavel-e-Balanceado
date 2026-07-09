class_name HUDJogador
extends Control

signal sair_partida

@export var menu_pause: HudMenuPause

@onready var label_relogio: Label = $Relogio/LabelRelogio
@onready var label_info_tempo: Label = %LabelInfoTempo

@onready var texture_vida_prog: TextureRect = $Vida/TextureProg
@onready var texture_mana_prog: TextureRect = $Mana/TextureProg
@onready var texture_mana_prog_atual: TextureRect = $Mana/TextureProgAtual

@onready var texture_prev: TextureRect = $SelecaoMagia/TexturePrev
@onready var texture_atual: TextureRect = $SelecaoMagia/TextureAtual
@onready var texture_prox: TextureRect = $SelecaoMagia/TextureProx
@onready var magia_mira: TextureRect = %MagiaMira

@onready var efeitos: Control = $Efeitos
@onready var congelado: TextureRect = $Efeitos/Congelado

@onready var sprite_hit: Sprite2D = $HudAim/PivotCentro/SpriteHit

var custo_mana_porcent: float = 0.0

var feitico_id_to_icon : Dictionary[String, Texture2D] = {}
var idx_to_feitico_id : Dictionary[int, String] = {}

## Para dado Feitico_id marca se esse feitico esta no lancavel (e pode ser usado)
var esta_lancavel_feitico_id: Dictionary[String, bool] = {}
## Cor do modulate no icone que nao esta apto a ser lancado
@export var cor_modulate_bloqueado := Color.WEB_GRAY

func _input(event):
	# esc para sair do capture
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		menu_pause.show()
	# click
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if not menu_pause.visible: # menu pause nao esta visivel
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _ready() -> void:
	# menu de pause
	menu_pause.hide()
	menu_pause.voltar_partida.connect(_esconder_menu_pause)
	menu_pause.sair_partida.connect(func(): sair_partida.emit())
	#	ajustar os feiticos
	menu_pause.set_feiticos(GlobalDeck.cards_escolhidos)
	# tela de fim de jogo
	tela_fim.hide()
	# tempo
	label_info_tempo.hide()
	# efeitos
	efeitos.show()
	congelado.hide()
	# mira
	sprite_hit.hide()
	# ajusta icones e feiticos por index
	var idx: int = 0
	for feitico_id: String in GlobalDeck.feiticos_id_escolhidos:
		var feitico_def = Registros.reg_feiticos.feiticos[feitico_id]
		add_icon(feitico_id, feitico_def.icone_hud)
		idx_to_feitico_id[idx] = feitico_id
		idx += 1
	
	# inicia os mostradores
	mostrar_vida(1.0)
	mostrar_mana(1.0)


# Icones Feiticos
# -----------------------------------------------------------------------------

func add_icon(feitico_id: String, icon) -> void:
	feitico_id_to_icon[feitico_id] = icon

func selecionar_magia(idx: int) -> void:
	if idx < 0 or idx > feitico_id_to_icon.size(): return
	
	# prev
	texture_prev.texture = _idx_to_icon(GlobalDeck.calc_add_idx(idx, -1) )
	# prox
	texture_prox.texture = _idx_to_icon(GlobalDeck.calc_add_idx(idx, +1) )
	# atual
	texture_atual.texture = _idx_to_icon(idx)
	magia_mira.texture = _idx_to_icon(idx)
	# verifica se esta apto a ser lancado
	var feitico_id: String = idx_to_feitico_id[idx]
	if esta_lancavel_feitico_id.get(feitico_id, true):
		texture_atual.modulate = Color.WHITE
		magia_mira.modulate = Color.WHITE
	else:
		texture_atual.modulate = cor_modulate_bloqueado
		magia_mira.modulate = cor_modulate_bloqueado

func _idx_to_icon(idx: int) -> Texture2D:
	return feitico_id_to_icon[idx_to_feitico_id[idx]]

func get_feitico_id_from_idx(idx: int) -> String:
	return idx_to_feitico_id[idx]


# Mostradores
# -----------------------------------------------------------------------------

func mostrar_vida(porcent_vida: float) -> void:
	# limita minimo em 0.0
	porcent_vida = max(porcent_vida, 0.0)
	# atualiza o icone na hud
	texture_vida_prog.scale.x = porcent_vida

func mostrar_mana(porcent_mana: float) -> void:
	# limita minimo em 0.0
	porcent_mana = max(porcent_mana, 0.0)
	var mana_prevista : float = max(porcent_mana - custo_mana_porcent, 0.0)
	# atualiza o icone na hud
	texture_mana_prog_atual.scale.x = porcent_mana
	texture_mana_prog.scale.x = mana_prevista

func atualizar_custo_mana_previsto(porcent_custo_mana: float) -> void:
	# atualiza o custo de mana
	custo_mana_porcent = porcent_custo_mana
	# mostra custo de mana
	mostrar_mana(texture_mana_prog_atual.scale.x)

func mostrar_hit() -> void:
	sprite_hit.show()
	await get_tree().create_timer(0.4).timeout
	sprite_hit.hide()

# Efeitos
# -----------------------------------------------------------------------------

func efeito_congelado(duracao_seg: float) -> void:
	congelado.material.set_shader_parameter("coverage", 0.0)
	congelado.show()
	
	# se o efeito durar muito pouco, nao faca o tween
	if (duracao_seg < 1.5):
		congelado.material.set_shader_parameter("coverage", 1.0)
		get_tree().create_timer(duracao_seg).timeout.connect(
			func(): 
				congelado.material.set_shader_parameter("coverage", 0.0)
				congelado.hide()
		)
		return
	
	# aplica o tween
	
	# tira 1.5 seg para o tween de colocar e tirar
	duracao_seg -= 1.5
	# tween de fade in
	var tween_in := create_tween()
	tween_in.set_ease(Tween.EASE_IN)
	tween_in.set_trans(Tween.TRANS_QUAD)
	tween_in.tween_property(
		congelado.material,
		"shader_parameter/coverage",
		1.0,
		0.6 # duracao
	).from_current()
	await tween_in.finished
	# espera o tempo q sobrar
	await get_tree().create_timer(duracao_seg).timeout
	# tween de fade out
	var tween_out := create_tween()
	tween_out.set_ease(Tween.EASE_IN)
	tween_out.set_trans(Tween.TRANS_CUBIC)
	tween_out.tween_property(
		congelado.material,
		"shader_parameter/coverage",
		0.25, # efeito para nesse nivel
		1.0 # duracao (soma pode ser maior que 1.5)
	).from_current()
	await tween_out.finished
	# acaba o efeito
	congelado.hide()

# Tempo Partida
# -----------------------------------------------------------------------------

func atualizar_tempo_restante_seg(_tempo_restante_seg: float) -> void:
	var tempo_seg: int = int(_tempo_restante_seg) % 60
	var tempo_min: int = int((_tempo_restante_seg - tempo_seg) / 60)
	label_relogio.text = "%d:%02d" % [tempo_min, tempo_seg]

func mostrar_minuto_final() -> void:
	label_info_tempo.text = "Minuto Final"
	_mostrar_info_tempo()

func mostrar_final_tempo() -> void:
	label_info_tempo.text = "Fim do Tempo"
	_mostrar_info_tempo()


func _mostrar_info_tempo() -> void:
	label_info_tempo.modulate.a = 0
	label_info_tempo.show()
	# anim mostrar
	var tween_alpha := create_tween()
	tween_alpha.tween_property(label_info_tempo, "modulate:a", 1.0, 1.0).from(0.0)
	
	var tween_pos := create_tween()
	tween_pos.set_ease(Tween.EASE_OUT)
	tween_pos.tween_property(
		label_info_tempo, "position:y",
		label_info_tempo.position.y,
		0.9
	).from(label_info_tempo.position.y - 20)
	# esconde depois de alguns segundos
	get_tree().create_timer(5.0).timeout.connect(_esconder_info_tempo)

func _esconder_info_tempo() -> void:
	var tween_alpha := create_tween()
	tween_alpha.set_ease(Tween.EASE_OUT)
	tween_alpha.tween_property(label_info_tempo, "modulate:a", 0.0, 0.7).from(1.0)
	
	# guarda a posicao atual, para manter essa sempre essa posicao
	var end_pos_y := label_info_tempo.position.y
	
	var tween_pos := create_tween()
	tween_pos.set_ease(Tween.EASE_OUT)
	tween_pos.tween_property(
		label_info_tempo, "position:y",
		label_info_tempo.position.y - 15,
		0.8
	).from_current()
	
	# espera acabar o tween
	await tween_alpha.finished
	# reseta posicao e esconde
	label_info_tempo.hide()
	label_info_tempo.position.y = end_pos_y

# Menu Pause
# -----------------------------------------------------------------------------
func _esconder_menu_pause() -> void:
	menu_pause.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Tela Fim
# -----------------------------------------------------------------------------

# TODO: arrumar isso
@onready var tela_fim: Control = $TelaFim
@onready var label_vitoria: Label = $TelaFim/LabelVitoria
func mostrar_tela_fim(ganhou: bool, nome_ganhador: String) -> void:
	var condicao := "Vitória" if ganhou else "Derrota"
	label_vitoria.text = label_vitoria.text.format({"condicao": condicao, "nome": nome_ganhador})
	tela_fim.show()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	menu_pause.modulate.a = 0.0

func _on_button_voltar_menu_pressed() -> void:
	sair_partida.emit()
