class_name RegistroFeiticos
extends Node

@export var feiticos : Dictionary[String, FeiticoDef] = {}

## Resource ListaFeiticosRes
const LISTA_FEITICOS = preload("uid://b0ks5dv5ssm2l")


func add_feitico(feitico_def : FeiticoDef) -> void:
	var feitico_id : String = feitico_def.feitico_id
	feiticos[feitico_id] = feitico_def

func get_feitico(feitico_id: String) -> FeiticoDef:
	return feiticos.get(feitico_id, null)

func _ready() -> void:
	for feitico_def in LISTA_FEITICOS.lista_feiticos:
		add_feitico(feitico_def)
