class_name FeiticoEfeitoInstantaneoImpulso
extends FeiticoEfeito

var velocidade_adicional: float = 10.0
var direcao: Vector3 = Vector3.UP

func aplicar(jogador: Jogador) -> void:
	jogador.velocity = velocidade_adicional * direcao
