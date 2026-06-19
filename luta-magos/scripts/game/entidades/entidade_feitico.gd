class_name EntidadeFeitico
extends Entidade

var criador_id: int = 0

func revelar(duracao_seg: float) -> void:
	if corpo is StaticBodyArmadilha:
		var arm: StaticBodyArmadilha = corpo
		arm.toggle_shader_revelacao(true)
		get_tree().create_timer(duracao_seg).timeout.connect(
			func(): arm.toggle_shader_revelacao(false)
		)
