class_name LocalAdm
extends Node

@export var hud : HUDJogador

@export var lancador_feiticos : LancadorFeiticos

var jogador : Jogador

func _ready() -> void:
	hud.show()
	lancador_feiticos.hud_jogador = hud
	lancador_feiticos.lancar_feitico.connect(_enviar_lancar_feitico)

func ajusta_para_jogador(_jogador: Jogador) -> void:
	jogador = _jogador
	_ajustar_hud()
	_ajustar_lancador_feiticos()

func ajusta_dados_jogador(_dados_jog: DadosJogador) -> void:
	# passa o id do jogador para o lancador de feiticos
	lancador_feiticos.jogador_id = jogador.dados_jogador.peer_id

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
