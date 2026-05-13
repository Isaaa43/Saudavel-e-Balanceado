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
# Temp - Resources

const FD_BOLA_FOGO = "uid://c4ct5q6ves50i"
const FD_FURA_SAPATO = "uid://c71eh6rcojqh0"
const FD_PULO_IMPULSIONADO = "uid://skatmcv3uduk"
const FD_OZEMPAGIC = "uid://cy0n07ui1fty2"
const FD_TO_TE_VENDO = "uid://c5nanmgoej3wa"

const feiticos_definicoes_res := [
	FD_BOLA_FOGO,
	FD_FURA_SAPATO,
	FD_PULO_IMPULSIONADO,
	FD_OZEMPAGIC,
	FD_TO_TE_VENDO,
]
