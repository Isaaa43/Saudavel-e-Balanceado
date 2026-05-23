class_name FeiticoComportamentoProjetil
extends FeiticoComportamento

var velocidade: float
var perfurar: bool

var efeitos_impacto : Array[FeiticoEfeito] = []

func physics_process(delta: float) -> void:
	corpo.global_position += direcao * velocidade * delta

func aplicar_efeitos(jogador: Jogador) -> void:
	for efeito : FeiticoEfeito in efeitos_impacto:
		efeito.aplicar(jogador)
