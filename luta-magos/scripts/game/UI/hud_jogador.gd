class_name HUDJogador
extends Control

@onready var icons: Array[Node] = $HBoxIcones.get_children()

@onready var color_rect_vida_baixo: ColorRect = $Vida/ColorRectVidaBaixo
@onready var color_rect_vida: ColorRect = $Vida/ColorRectVida

func _ready() -> void:
	selecionar_magia(0)
	display_vida(1)

func selecionar_magia(id: int) -> void:
	# deixa todos os icones no padrao
	for icon in icons:
		icon.modulate = Color(1.0, 1.0, 1.0, 1.0)
	# magia escolhida
	icons[id].modulate = Color(2.454, 2.454, 2.454)

func display_vida(porcent: float) -> void:
	color_rect_vida.size.x = color_rect_vida_baixo.size.x * porcent
