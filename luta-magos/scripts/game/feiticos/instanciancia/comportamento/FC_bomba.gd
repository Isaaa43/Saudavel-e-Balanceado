class_name FeiticoComportamentoBomba
extends FeiticoComportamento

var velocidade: float

var tamanho_raio: float

var efeitos_impacto : Array[FeiticoEfeito] = []

var direcao := Vector3.ZERO

func iniciar_comportamento() -> void:
	direcao = contexto.direcao
	if corpo.corpo_movimento is RigidBody3D:
		corpo.corpo_movimento.apply_impulse(direcao * velocidade)

func physics_process(delta: float) -> void:
	pass
