class_name FeiticoEfeitoGanharMana
extends FeiticoEfeito

func _aplicar(jogador: Jogador) -> void:
	if jogador.sistema_mana:
		jogador.sistema_mana.ganhar_mana(valor)
