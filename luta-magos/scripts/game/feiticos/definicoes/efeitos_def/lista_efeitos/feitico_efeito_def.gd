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

@export var modificador_def : FeiticoModificadorEfeitoDef


func criar() -> FeiticoEfeito:
	var efeito := _criar()
	efeito.tipo = tipo
	efeito.valor = valor
	if modificador_def: efeito.modificador = modificador_def.criar()
	return efeito

@abstract
func _criar() -> FeiticoEfeito
