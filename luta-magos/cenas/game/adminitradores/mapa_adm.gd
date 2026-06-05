extends Node
class_name MapaAdm

@export var spawns : Array[Node3D]

func get_spawn() -> Array[Vector3]:
	var spawn_locations = spawns.pick_random()
	var posicoes: Array[Vector3] = []
	for c : Node3D in spawn_locations.get_children():
		posicoes.append(c.global_position)
	return posicoes
