class_name UIAdm
extends Node

@export var hud : HUDJogador

func _ready() -> void:
	hud.show()

func set_hud_jogador(jogador: Jogador) -> void:
	# adiciona hud no jogador
	jogador.hud = hud
