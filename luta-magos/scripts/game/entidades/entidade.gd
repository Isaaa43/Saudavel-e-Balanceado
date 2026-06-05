@abstract
class_name Entidade
extends Node

@export var receptor_efeitos: ReceptorEfeitos
@export var corpo: PhysicsBody3D

func _ready() -> void:
	corpo.set_meta("entidade", self)

static func get_entidade_from_corpo(nodo: Node3D) -> Entidade:
	if nodo and nodo.has_meta("entidade"):
		return nodo.get_meta("entidade") as Entidade
	return null
