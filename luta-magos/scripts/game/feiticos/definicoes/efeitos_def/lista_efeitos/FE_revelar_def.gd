class_name FeiticoEfeitoRevelarDef
extends FeiticoEfeitoDef

@export_group("Revelar")

func _criar() -> FeiticoEfeitoRevelar:
	var efeito := FeiticoEfeitoRevelar.new()
	return efeito
