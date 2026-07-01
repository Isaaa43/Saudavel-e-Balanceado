class_name FeiticoEfeitoMudarVelocidadeDef
extends FeiticoEfeitoDef

@export var duracao_seg: float = 1.0

func _criar() -> FeiticoEfeitoMudarVelocidade:
	var efeito := FeiticoEfeitoMudarVelocidade.new()
	efeito.duracao_seg = duracao_seg
	return efeito
