extends Node

@onready var feiticos: Node = $Feiticos

@export var spell_registry: RegistroFeiticos

func _ready() -> void:
	NetworkClient.spawn_feitico.connect(_spawnar_feitico)

func _spawnar_feitico(feitico_id : String, target_pos: Vector3) -> void:
	
	var definition = spell_registry.get_feitico(feitico_id)
	if not definition: return

	var spell: Feitico = definition.feitico_scene.instantiate()
	#get_tree().current_scene.add_child(spell)
	feiticos.add_child(spell)

	spell.feitico_id       = feitico_id
	spell.criador         = get_parent()
	spell.direcao = target_pos
	spell.alvo    = null

	spell.lancar()
