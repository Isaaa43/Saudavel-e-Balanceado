class_name FeiticoEfeitoImpulso
extends FeiticoEfeito

var direcao: Vector3 = Vector3.UP

func _aplicar(jogador: Jogador) -> void:
	jogador.velocity = valor * direcao
