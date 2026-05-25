class_name FeiticoEfeitoInstantaneoDano
extends FeiticoEfeito

var dano: float = 0.0

func aplicar(jogador: Jogador) -> void:
	jogador.sistema_vida.receber_dano(dano)
