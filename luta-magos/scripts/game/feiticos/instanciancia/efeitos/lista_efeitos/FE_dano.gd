class_name FeiticoEfeitoDano
extends FeiticoEfeito

func _aplicar(jogador: Jogador) -> void:
	jogador.sistema_vida.receber_dano(valor)
