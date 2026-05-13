class_name HUDJogador
extends Control

@onready var icons: Array[Node] = $HBoxIcones.get_children()

@onready var color_rect_vida_baixo: ColorRect = $Vida/ColorRectVidaBaixo
@onready var color_rect_vida: ColorRect = $Vida/ColorRectVida

@onready var color_rect_mana_baixo: ColorRect = $Mana/ColorRectManaBaixo
@onready var color_rect_mana: ColorRect = $Mana/ColorRectMana

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
	color_rect_vida.size.x = color_rect_vida_baixo.size.x * porcent_vida

func mostrar_mana(porcent_mana: float) -> void:
	color_rect_mana.size.x = color_rect_mana_baixo.size.x * porcent_mana
	
