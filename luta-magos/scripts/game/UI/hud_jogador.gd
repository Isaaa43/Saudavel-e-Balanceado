class_name HUDJogador
extends Control

signal sair_partida

@export var menu_pause: HudMenuPause

@onready var label_relogio: Label = $Relogio/LabelRelogio

@onready var texture_vida_prog: TextureRect = $Vida/TextureProg
@onready var texture_mana_prog: TextureRect = $Mana/TextureProg
@onready var texture_mana_prog_atual: TextureRect = $Mana/TextureProgAtual

@onready var texture_prev: TextureRect = $SelecaoMagia/TexturePrev
@onready var texture_atual: TextureRect = $SelecaoMagia/TextureAtual
@onready var texture_prox: TextureRect = $SelecaoMagia/TextureProx

var custo_mana_porcent: float = 0.0

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
	menu_pause.hide()
	menu_pause.voltar_partida.connect(_esconder_menu_pause)
	menu_pause.sair_partida.connect(func(): sair_partida.emit())
	
	tela_fim.hide()
	
	var idx: int = 0
	for feitico_id: String in GlobalDeck.feiticos_id_escolhidos:
		var feitico_def = Registros.reg_feiticos.feiticos[feitico_id]
		add_icon(feitico_id, feitico_def.icone_hud)
		idx_to_feitico_id[idx] = feitico_id
		idx += 1
	
	selecionar_magia(idx_atual)
	# inicia os mostradores
	mostrar_vida(1.0)
	mostrar_mana(1.0)


var feitico_id_to_icon : Dictionary[String, Texture2D] = {}
var idx_to_feitico_id : Dictionary[int, String] = {}
var idx_atual := 1
func add_icon(feitico_id: String, icon) -> void:
	feitico_id_to_icon[feitico_id] = icon

func selecionar_magia(idx: int) -> void:
	if idx < 0 or idx > feitico_id_to_icon.size(): return
	
	# prev
	if idx > 0:
		texture_prev.show()
		texture_prev.texture = feitico_id_to_icon[idx_to_feitico_id[idx-1]]
	else:
		texture_prev.hide()
	
	# prov
	if idx < feitico_id_to_icon.size()-1:
		texture_prox.show()
		texture_prox.texture = feitico_id_to_icon[idx_to_feitico_id[idx+1]]
	else:
		texture_prox.hide()
	
	texture_atual.texture = feitico_id_to_icon[idx_to_feitico_id[idx]]

func get_feitico_id_from_idx() -> String:
	return idx_to_feitico_id[idx_atual]

func add_idx(qnt: int ) -> void:
	idx_atual = idx_atual + qnt
	idx_atual = min(idx_atual, idx_to_feitico_id.size()-1)
	idx_atual = max(idx_atual, 0)
	selecionar_magia(idx_atual)

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

func atualizar_tempo_restante_seg(_tempo_restante_seg: float) -> void:
	var tempo_seg: int = int(_tempo_restante_seg) % 60
	var tempo_min: int = int((_tempo_restante_seg - tempo_seg) / 60)
	label_relogio.text = "%d:%02d" % [tempo_min, tempo_seg]

func _esconder_menu_pause() -> void:
	menu_pause.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

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
