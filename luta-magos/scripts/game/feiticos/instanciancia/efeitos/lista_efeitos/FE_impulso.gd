class_name FeiticoEfeitoImpulso
extends FeiticoEfeito

var direcao: Vector3 = Vector3.UP

func _aplicar(entidade: Entidade) -> void:
	entidade.corpo.velocity = valor * direcao
