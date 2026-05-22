class_name FeiticoComportamentoProjetil
extends FeiticoComportamento

var velocidade: float
var perfura: bool

func physics_process(delta: float) -> void:
	corpo.global_position += direcao * velocidade * delta
