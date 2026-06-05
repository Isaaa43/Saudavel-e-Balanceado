class_name FeiticoEfeitoDano
extends FeiticoEfeito

func _aplicar(entidade: Entidade) -> void:
	entidade.sistema_vida.receber_dano(valor)
