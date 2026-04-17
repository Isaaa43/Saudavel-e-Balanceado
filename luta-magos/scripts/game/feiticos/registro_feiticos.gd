class_name RegistroFeiticos
extends Node

@export var feiticos : Dictionary[String, FeiticoDefinicao] = {}

func add_feitico(feitico_id: String, feitico_def : FeiticoDefinicao) -> void:
	feiticos[feitico_id] = feitico_def

func get_feitico(feitico_id: String) -> FeiticoDefinicao:
	return feiticos.get(feitico_id, null)
