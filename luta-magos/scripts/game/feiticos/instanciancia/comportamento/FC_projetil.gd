class_name FeiticoComportamentoProjetil
extends FeiticoComportamento

var velocidade: float
var perfurar: bool

var efeitos_impacto : Array[FeiticoEfeito] = []

var direcao := Vector3.ZERO

func iniciar_comportamento() -> void:
	direcao = contexto.direcao

func physics_process(delta: float) -> void:
	corpo.global_position += direcao * velocidade * delta

func aplicar_efeitos(jogador: Jogador) -> void:
	for efeito : FeiticoEfeito in efeitos_impacto:
		efeito.aplicar(jogador)
