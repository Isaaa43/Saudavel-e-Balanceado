class_name LocalAdm
extends Node

signal pediu_sair_partida

@export var hud : HUDJogador

@export var lancador_feiticos : LancadorFeiticos

var jogador : Jogador

func _ready() -> void:
	hud.show()
	lancador_feiticos.hud_jogador = hud
	lancador_feiticos.lancar_feitico.connect(_enviar_lancar_feitico)
	#
	hud.menu_pause.sensibilidade_mira_atualizada.connect(_atualizar_sensibilidade_mira)
	hud.menu_pause.sair_partida.connect(_pedir_sair_partida)

func ajusta_para_jogador(_jogador: Jogador) -> void:
	jogador = _jogador
	_ajustar_hud()
	_ajustar_lancador_feiticos()

func ajusta_dados_jogador(_dados_jog: DadosJogador) -> void:
	# passa o id do jogador para o lancador de feiticos
	lancador_feiticos.jogador_id = jogador.dados_jogador.peer_id

func ajusta_tempo_partida(_tempo_restante_seg: float) -> void:
	hud.atualizar_tempo_restante_seg(_tempo_restante_seg)

func _ajustar_hud() -> void:
	# conectar hud as mudanca de atributos do jogador
	jogador.sistema_vida.mudanca_vida.connect(hud.mostrar_vida)
	jogador.sistema_mana.mudanca_mana.connect(hud.mostrar_mana)

func _ajustar_lancador_feiticos() -> void:
	# conectar lancador de feiticos com o sistema de mana
	lancador_feiticos.sistema_mana = jogador.sistema_mana
	# prende o lancador de feiticos na visao da camera
	jogador.camera_jogador.set_target_remote_transform_mira(lancador_feiticos.get_path())

func _enviar_lancar_feitico(feitico_contexto: FeiticoContexto) -> void:
	Network.client.lancar_feitico(feitico_contexto)

func _atualizar_sensibilidade_mira(sensi: float) -> void:
	jogador.camera_jogador.set_sensibilidade(sensi)

func _pedir_sair_partida() -> void:
	pediu_sair_partida.emit()
