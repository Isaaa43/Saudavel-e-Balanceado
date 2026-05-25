class_name FeiticoEfeitoImpulsoDef
extends FeiticoEfeitoDef

@export_group("Impulso Adicional")
@export var direcao: Vector3 = Vector3.UP

func _criar() -> FeiticoEfeitoImpulso:
	var efeito := FeiticoEfeitoImpulso.new()
	efeito.direcao = direcao.normalized()
	return efeito
