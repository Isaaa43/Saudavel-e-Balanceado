class_name UIAdm
extends Node

@export var hud : HUDJogador

var jogador : Jogador

func _ready() -> void:
	hud.show()

func ajustar_hud_jogador(_jogador: Jogador) -> void:
	jogador = _jogador
	
	# mudanca de vida na hud
	jogador.sistema_vida.mudanca_vida.connect(hud.mostrar_vida)
	
	# TODO: arrumar
	jogador.lancador_feiticos.hud_jogador = hud
