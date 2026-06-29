class_name SistemaMovimentoTreino
extends SistemaMovimento

func _process(delta: float) -> void:
	# Add the gravity.
	if not jogador.is_on_floor():
		jogador.velocity += jogador.get_gravity() * delta

	jogador.move_and_slide()
