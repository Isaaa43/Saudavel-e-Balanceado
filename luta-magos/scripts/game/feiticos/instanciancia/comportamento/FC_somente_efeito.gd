class_name FeiticoComportamentoSomenteEfeito
extends FeiticoComportamento

var efeitos : Array[FeiticoEfeito] = []

func physics_process(delta: float) -> void:
	pass

func aplicar_efeitos(jogador: Jogador) -> void:
	for efeito : FeiticoEfeito in efeitos:
		efeito.aplicar(jogador)
