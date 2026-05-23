class_name FeiticoEfeitoInstantaneoCura
extends FeiticoEfeito

var cura: float = 0.0

func aplicar(jogador: Jogador) -> void:
	jogador.receber_vida(cura)
