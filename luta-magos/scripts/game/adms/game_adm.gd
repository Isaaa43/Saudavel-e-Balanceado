class_name GameAdm
extends Node

@export var jogadores_adm : JogadoresAdm
@export var local_adm : LocalAdm
@export var timer_adm: TimerAdm

func _ready() -> void:
	# ajustar sinais
	jogadores_adm.recebido_jogador_authority.connect(local_adm.ajusta_para_jogador)
	jogadores_adm.recebido_dados_jog_authority.connect(local_adm.ajusta_dados_jogador)
	timer_adm.tempo_atualizado.connect(local_adm.ajusta_tempo_partida)
	
	#TODO: hmm lugar melhot
	timer_adm.iniciar()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Network.client.pedir_terminar_partida()
