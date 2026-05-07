class_name HUDJogador
extends Control

@onready var icons: Array[Node] = $HBoxContainer.get_children()

@onready var color_rect_vida_baixo: ColorRect = $Vida/ColorRectVidaBaixo
@onready var color_rect_vida: ColorRect = $Vida/ColorRectVida
var color_rect_vida_size: float

var vida: int
var vida_inicial: int = 200

func _ready() -> void:
	vida = vida_inicial
	color_rect_vida_size = color_rect_vida_baixo.size.x
	_update_vida_bar()

func selecionar(id: int) -> void:
	for icon in icons:
		icon.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	icons[id].modulate = Color(2.454, 2.454, 2.454)

func levar_dano(dano: int) -> void:
	vida = max(0, vida - dano)
	_update_vida_bar()
	
	# acabar partida
	if is_zero_approx(dano):
		await get_tree().create_timer(0.7).timeout
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		NetworkServer.terminar_partida()
	

func _update_vida_bar() -> void:
	var porcent : float = float(vida) / vida_inicial
	print("porcent ", porcent)
	color_rect_vida.size.x = color_rect_vida_size * porcent
	
