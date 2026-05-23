class_name FeiticoEfeitoDanoInstantaneoDef
extends FeiticoEfeitoDef

@export_group("Dano Intantaneo")
@export var dano: float = 0.0

func criar() -> FeiticoEfeitoDanoInstantaneo:
	var efeito := FeiticoEfeitoDanoInstantaneo.new()
	efeito.dano = dano
	return efeito
