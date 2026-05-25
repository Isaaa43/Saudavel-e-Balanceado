class_name FeiticoEfeitoDuradouroRegenMana
extends FeiticoEfeito

var qntd_mana: float = 0.0
var cooldown_seg: float = 0.0

func aplicar(jogador: Jogador) -> void:
	if jogador.sistema_mana:
		jogador.sistema_mana.ganhar_mana(qntd_mana)
