extends Node

@export var jogadores_adm : JogadoresAdm

@onready var feiticos: Node = $Feiticos

@onready var spell_registry: RegistroFeiticos = Registros.reg_feiticos

func _ready() -> void:
	Network.client.spawnar_feitico.connect(_spawnar_feitico)


func _spawnar_feitico(feitico_contexto : FeiticoContexto) -> void:
	var feitico_id : String = feitico_contexto.feitico_id
	var feitico_def : FeiticoDef = spell_registry.get_feitico(feitico_id)
	if (not feitico_id) or (not feitico_def): return
	
	var feitico: Feitico = feitico_def.criar_feitico()
	feitico_contexto.aplicar_contexto(feitico)
	feitico.criador = _get_jogador_peer_id(feitico_contexto.criador)
	
	feitico.name = feitico_id + "_1"
	feiticos.add_child(feitico, true)
	
	feitico.criar()
	feitico.lancar()

func _get_jogador_peer_id(peer_id: int) -> Jogador:
	return jogadores_adm.get_jogador_peer_id(peer_id)
