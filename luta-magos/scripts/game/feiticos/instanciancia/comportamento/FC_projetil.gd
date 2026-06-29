class_name FeiticoComportamentoProjetil
extends FeiticoComportamento

var velocidade: float
var perfurar: bool

var tamanho_raio: float

var efeitos_impacto : Array[FeiticoEfeito] = []

var direcao := Vector3.ZERO

func iniciar_comportamento() -> void:
	direcao = contexto.direcao

func physics_process(delta: float) -> void:
	corpo.corpo_movimento.global_position += direcao * velocidade * delta
