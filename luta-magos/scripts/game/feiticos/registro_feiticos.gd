class_name RegistroFeiticos
extends Node

@export var feiticos : Dictionary[String, FeiticoDefinicaoRes] = {}

func add_feitico(feitico_id: String, feitico_def : FeiticoDefinicaoRes) -> void:
	feiticos[feitico_id] = feitico_def

func get_feitico(feitico_id: String) -> FeiticoDefinicaoRes:
	return feiticos.get(feitico_id, null)
