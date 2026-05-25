class_name FeiticoEfeitoCura
extends FeiticoEfeito

func _aplicar(jogador: Jogador) -> void:
	jogador.sistema_vida.receber_vida(valor)
