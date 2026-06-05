@abstract
class_name FeiticoEfeito
extends RefCounted

enum Tipo {INSTANTANEO, DURACAO, PERSISTENTE}

var tipo := Tipo.INSTANTANEO
var valor: float

var modificador: FeiticoModificadorEfeito

@abstract
func _aplicar(entidade: Entidade) -> void

func aplicar(entidade: Entidade) -> void:
	_aplicar(entidade)


func has_modificador() -> bool:
	if modificador and is_instance_valid(modificador):
		return true
	return false
