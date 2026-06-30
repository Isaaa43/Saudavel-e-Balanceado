class_name LocalAdm
extends Node

signal pediu_sair_partida

@export var hud : HUDJogador

@export var lancador_feiticos : LancadorFeiticos

## Distancia maxima que os jogadores podem se ver
@export var distancia_visao: float = 14.0
@onready var dist_visao_sqrd := distancia_visao ** 2

## Feitico Id de cura para ser bloqueado no final do jogo
@export var feitico_id_cura_bloquear: String = "Cura"

var jogador : Jogador
var outros_jogadores: Array[Jogador]

func _ready() -> void:
	hud.show()
	lancador_feiticos.hud_jogador = hud
	lancador_feiticos.lancar_feitico.connect(_enviar_lancar_feitico)
	#
	hud.menu_pause.sensibilidade_mira_atualizada.connect(_atualizar_sensibilidade_mira)
	hud.sair_partida.connect(_pedir_sair_partida)

# Ajustar para jogador
# -----------------------------------------------------------------------------

func ajusta_para_jogador(_jogador: Jogador) -> void:
	jogador = _jogador
	_ajustar_hud()
	_ajustar_lancador_feiticos()

func ajusta_dados_jogador(_dados_jog: DadosJogador) -> void:
	# passa o id do jogador para o lancador de feiticos
	var jogador_id : int = jogador.dados_jogador.peer_id
	lancador_feiticos.jogador_id = jogador_id
	Registros.jogador_id_local = jogador_id

func ajusta_tempo_partida(_tempo_restante_seg: float) -> void:
	hud.atualizar_tempo_restante_seg(_tempo_restante_seg)

func _ajustar_hud() -> void:
	# conectar hud as mudanca de atributos do jogador
	jogador.sistema_vida.mudanca_vida.connect(hud.mostrar_vida)
	jogador.sistema_mana.mudanca_mana.connect(hud.mostrar_mana)
	jogador.sistema_movimento.congelado.connect(hud.efeito_congelado)

func _ajustar_lancador_feiticos() -> void:
	# conectar lancador de feiticos com o sistema de mana
	lancador_feiticos.sistema_mana = jogador.sistema_mana
	# prende o lancador de feiticos na visao da camera
	jogador.camera_jogador.set_target_remote_transform_mira(lancador_feiticos.get_path())
# Lancar Feiticos
# -----------------------------------------------------------------------------

func _enviar_lancar_feitico(feitico_contexto: FeiticoContexto) -> void:
	Network.client.lancar_feitico(feitico_contexto)
	# animacao
	var anim := SistemaAnimacao.Animacao.ATACAR
	jogador.jogador_corpo.sistema_animacao.acao(anim)

# Configuracoes Jogador
# -----------------------------------------------------------------------------

func _atualizar_sensibilidade_mira(sensi: float) -> void:
	jogador.camera_jogador.set_sensibilidade(sensi)

# Fim partida
# -----------------------------------------------------------------------------

func _pedir_sair_partida() -> void:
	pediu_sair_partida.emit()

func matar_jogador(_jogador: Jogador) -> void:
	if _jogador == jogador:
		lancador_feiticos.process_mode = Node.PROCESS_MODE_DISABLED

func tela_fim(jogador_ganhador: Jogador) -> void:
	if not jogador_ganhador: return
	var nome_ganhador: String = jogador_ganhador.dados_jogador.nome
	hud.mostrar_tela_fim(jogador == jogador_ganhador, nome_ganhador)

# Bloquear Cura
# -----------------------------------------------------------------------------

func bloquear_cura() -> void:
	lancador_feiticos.bloquear_feitico(feitico_id_cura_bloquear)

# Outros jogadores
# -----------------------------------------------------------------------------
func outro_jogador(_jogador: Jogador) -> void:
	outros_jogadores.append(_jogador)

func _physics_process(_delta: float) -> void:
	for jog: Jogador in outros_jogadores:
		var dist_sqrd := jog.jogador_corpo.global_position.distance_squared_to(jogador.jogador_corpo.global_position)
		var visivel := dist_sqrd < dist_visao_sqrd
		jog.jogador_corpo.mesh_corpo.visivel_distancia(visivel)
