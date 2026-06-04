class_name HUDJogador
extends Control

@export var menu_pause: HudMenuPause

@onready var icons: Array[Node] = $HBoxIcones.get_children()

@onready var label_relogio: Label = $Relogio/LabelRelogio

@onready var texture_vida_prog: TextureRect = $Vida/TextureProg
@onready var texture_mana_prog: TextureRect = $Mana/TextureProg
@onready var texture_mana_prog_atual: TextureRect = $Mana/TextureProgAtual

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
	
	selecionar_magia(0)
	# inicia os mostradores
	mostrar_vida(1.0)
	mostrar_mana(1.0)

func selecionar_magia(id: int) -> void:
	# deixa todos os icones no padrao
	for icon in icons:
		icon.modulate = Color(1.0, 1.0, 1.0, 1.0)
	# magia escolhida
	icons[id].modulate = Color(2.454, 2.454, 2.454)

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
