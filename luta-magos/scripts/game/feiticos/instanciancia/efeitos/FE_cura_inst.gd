class_name FeiticoEfeitoCuraInstantaneo
extends FeiticoEfeito

var cura: float = 0.0

func aplicar(jogador: Jogador) -> void:
	jogador.receber_cura(cura)
