@abstract
class_name FeiticoEfeitoDef
extends Resource

#enum Tipo {
	#DANO,
	#CURA,
	#ESCUDO,
	#VELOCIDADE,
#}

const tipo := FeiticoEfeito.Tipo.INSTANTANEO

@export var modificador : FeiticoModificadorEfeitoDef

@export var valor: float

func criar() -> FeiticoEfeito:
	var efeito := _criar()
	efeito.tipo = tipo
	efeito.valor = valor
	return efeito

@abstract
func _criar() -> FeiticoEfeito
