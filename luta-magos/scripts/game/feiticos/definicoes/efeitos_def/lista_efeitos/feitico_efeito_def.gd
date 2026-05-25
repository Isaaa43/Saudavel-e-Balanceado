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

@export_group("Efeito Base")
@export var valor: float

@export var modificador : FeiticoModificadorEfeitoDef


func criar() -> FeiticoEfeito:
	var efeito := _criar()
	efeito.tipo = tipo
	efeito.valor = valor
	return efeito

@abstract
func _criar() -> FeiticoEfeito
