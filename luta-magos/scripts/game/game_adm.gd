class_name GameAdm
extends Node

@export var jogadores_adm : JogadoresAdm
@export var ui_adm : UIAdm

func _ready() -> void:
	# ajustar sinais
	jogadores_adm.colocar_hud_jogador.connect(ui_adm.ajustar_hud_jogador)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		NetworkServer.terminar_partida()
