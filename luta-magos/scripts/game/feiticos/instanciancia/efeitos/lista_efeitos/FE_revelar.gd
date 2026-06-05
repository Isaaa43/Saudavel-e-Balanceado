class_name FeiticoEfeitoRevelar
extends FeiticoEfeito

func _aplicar(entidade: Entidade) -> void:
	entidade.revelar(valor)
