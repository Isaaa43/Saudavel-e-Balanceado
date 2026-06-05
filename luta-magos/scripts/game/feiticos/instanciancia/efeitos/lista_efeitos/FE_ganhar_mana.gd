class_name FeiticoEfeitoGanharMana
extends FeiticoEfeito

func _aplicar(entidade: Entidade) -> void:
	if entidade.sistema_mana:
		entidade.sistema_mana.ganhar_mana(valor)
