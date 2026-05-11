class_name GameAdm
extends Node

@export var HUD_REF : PackedScene

@export var jogadores_adm : JogadoresAdm

func _ready() -> void:
	# ajustar sinais
	jogadores_adm.colocar_hud_jogador.connect(set_hud_jogador)

func set_hud_jogador(jogador: Jogador) -> void:
	var hud : HUDJogador = HUD_REF.instantiate()
	add_child(hud)
	# adiciona hud no jogador
	jogador.hud = hud

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		NetworkServer.terminar_partida()
