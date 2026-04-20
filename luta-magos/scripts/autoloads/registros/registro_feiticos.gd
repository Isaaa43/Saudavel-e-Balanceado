class_name RegistroFeiticos
extends Node

@export var feiticos : Dictionary[String, FeiticoDefinicaoRes] = {}

func add_feitico(feitico_def : FeiticoDefinicaoRes) -> void:
	var feitico_id : String = feitico_def.feitico_id
	feiticos[feitico_id] = feitico_def

func get_feitico(feitico_id: String) -> FeiticoDefinicaoRes:
	return feiticos.get(feitico_id, null)

func _ready() -> void:
	for feitico_def_ref in feiticos_definicoes_res:
		var feitico_def: FeiticoDefinicaoRes = load(feitico_def_ref)
		add_feitico(feitico_def)

# --------------------------------------------------------------------------------------------------

const FD_BOLA_FOGO = "uid://c4ct5q6ves50i"
const FD_FURA_SAPATO = "uid://c71eh6rcojqh0"

const feiticos_definicoes_res := [
	FD_BOLA_FOGO,
	FD_FURA_SAPATO,
]
