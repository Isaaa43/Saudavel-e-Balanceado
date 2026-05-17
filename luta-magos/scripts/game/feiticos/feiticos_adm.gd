extends Node

@export var jogadores_adm : JogadoresAdm

@onready var feiticos: Node = $Feiticos

@onready var spell_registry: RegistroFeiticos = Registros.reg_feiticos

func _ready() -> void:
	Network.client.spawnar_feitico.connect(_spawnar_feitico)

func _spawnar_feitico(feitico_contexto : FeiticoContexto) -> void:
	var feitico_id : String = feitico_contexto.feitico_id
	
	var feitico_def : FeiticoDefinicaoRes = spell_registry.get_feitico(feitico_id)
	if not feitico_def: return

	var feitico: Feitico = feitico_def.feitico_scene.instantiate()
	feiticos.add_child(feitico)

	feitico.feitico_id = feitico_id
	feitico.criador = _get_jogador_peer_id(feitico_contexto.criador)
	feitico.direcao = feitico_contexto.direcao
	feitico.alvo    = feitico_contexto.alvo
	feitico.posicao_global_inicial = feitico_contexto.posicao_global_inicial

	feitico.lancar()

func _get_jogador_peer_id(peer_id: int) -> Jogador:
	return jogadores_adm.get_jogador_peer_id(peer_id)
