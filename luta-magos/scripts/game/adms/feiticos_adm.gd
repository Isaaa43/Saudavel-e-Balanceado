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
	
	
	if multiplayer.is_server():
		var criador_id : int = feitico_contexto.criador_id
		var spell_id : String = feitico_contexto.feitico_id
		var posicao : Vector3 = feitico_contexto.posicao_global_inicial
		var direcao : Vector3 = feitico_contexto.direcao
		SaveData.registrar_feitico(criador_id, spell_id, posicao, direcao)
	
	var feitico: Feitico = feitico_def.criar_feitico(feitico_contexto)
	
	feitico.name = feitico_id + "_1"
	feiticos.add_child(feitico, true)
	
	feitico.criar()
	feitico.lancar()
