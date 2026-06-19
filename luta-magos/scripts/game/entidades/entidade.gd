#@abstract
class_name Entidade
extends Node

@export var receptor_efeitos: ReceptorEfeitos
@export var corpo: PhysicsBody3D

## sobrescreve a verificao de 'deve_aplicar_efeito'
@export var is_especial : bool = false

func revelar(duracao_seg: float) -> void:
	if corpo is JogadorCorpo:
		var jog: JogadorCorpo = corpo
		jog.toggle_shader_revelacao(true)
		get_tree().create_timer(duracao_seg).timeout.connect(
			func(): jog.toggle_shader_revelacao(false)
		)

func _ready() -> void:
	corpo.set_meta("entidade", self)

static func get_entidade_from_corpo(nodo: Node3D) -> Entidade:
	if nodo and nodo.has_meta("entidade"):
		return nodo.get_meta("entidade") as Entidade
	return null
