class_name FeiticoEfeitoCuraInstantaneoDef
extends FeiticoEfeitoDef

@export_group("Cura Intantaneo")
@export var cura: float = 0.0

func criar() -> FeiticoEfeitoCuraInstantaneo:
	var efeito := FeiticoEfeitoCuraInstantaneo.new()
	efeito.cura = cura
	return efeito
