class_name FeiticoEfeitoDanoInstantaneo
extends FeiticoEfeito

var dano: float = 0.0

func aplicar(jogador: Jogador) -> void:
	jogador.receber_dano(dano)
