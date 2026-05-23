class_name FeiticoEfeitoInstantaneoDanoDef
extends FeiticoEfeitoDef

@export_group("Dano Intantaneo")
@export var dano: float = 0.0

func criar() -> FeiticoEfeitoInstantaneoDano:
	var efeito := FeiticoEfeitoInstantaneoDano.new()
	efeito.dano = dano
	return efeito
