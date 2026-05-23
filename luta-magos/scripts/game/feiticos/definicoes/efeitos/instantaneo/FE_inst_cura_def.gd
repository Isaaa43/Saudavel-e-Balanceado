class_name FeiticoEfeitoInstantaneoCuraDef
extends FeiticoEfeitoDef

@export_group("Cura Intantaneo")
@export var cura: float = 0.0

func criar() -> FeiticoEfeitoInstantaneoCura:
	var efeito := FeiticoEfeitoInstantaneoCura.new()
	efeito.cura = cura
	return efeito
