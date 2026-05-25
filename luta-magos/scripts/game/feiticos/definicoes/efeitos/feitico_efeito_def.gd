@abstract
class_name FeiticoEfeitoDef
extends Resource

#enum Tipo {
	#DANO,
	#CURA,
	#ESCUDO,
	#VELOCIDADE,
#}

@export var tipo := FeiticoEfeito.Tipo.INSTANTANEO

func criar() -> FeiticoEfeito:
	var efeito := _criar()
	efeito.tipo = tipo
	return efeito

@abstract
func _criar() -> FeiticoEfeito
