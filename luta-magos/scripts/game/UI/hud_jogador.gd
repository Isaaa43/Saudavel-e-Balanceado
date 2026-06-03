class_name HUDJogador
extends Control

@onready var icons: Array[Node] = $HBoxIcones.get_children()

@onready var label_relogio: Label = $Relogio/LabelRelogio

@onready var texture_vida_prog: TextureRect = $Vida/TextureProg
@onready var texture_mana_prog: TextureRect = $Mana/TextureProg
@onready var texture_mana_prog_previsao: TextureRect = $Mana/TextureProgPrevisao

func _ready() -> void:
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
	# atualiza o icone na hud
	texture_mana_prog.scale.x = porcent_mana
	texture_mana_prog_previsao.scale.x = porcent_mana

func mostrar_previsao_mana(porcent_mana_previsto: float) -> void:
	# limita minimo em 0.0
	porcent_mana_previsto = max(porcent_mana_previsto, 0.0)
	# atualiza o icone na hud
	texture_mana_prog.scale.x = porcent_mana_previsto

func atualizar_tempo_restante_seg(_tempo_restante_seg: float) -> void:
	var tempo_seg: int = int(_tempo_restante_seg) % 60
	var tempo_min: int = int((_tempo_restante_seg - tempo_seg) / 60)
	label_relogio.text = "%d:%02d" % [tempo_min, tempo_seg]
