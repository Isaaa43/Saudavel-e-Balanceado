class_name FeiticoEfeitoCura
extends FeiticoEfeito

func _aplicar(entidade: Entidade) -> void:
	entidade.sistema_vida.receber_vida(valor)
