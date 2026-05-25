class_name FeiticoEfeitoInstantaneoImpulsoDef
extends FeiticoEfeitoDef

@export_group("Salto Intantaneo")
@export var velocidade_adicional: float = 10.0
@export var direcao: Vector3 = Vector3.UP

func _criar() -> FeiticoEfeitoInstantaneoImpulso:
	var efeito := FeiticoEfeitoInstantaneoImpulso.new()
	efeito.velocidade_adicional = velocidade_adicional
	efeito.direcao = direcao.normalized()
	return efeito
