class_name EntidadeFeitico
extends Entidade

var criador_id: int = 0

func revelar(duracao_seg: float) -> void:
	if corpo is StaticBodyArmadilha:
		var arm: StaticBodyArmadilha = corpo
		# liga o shader de revelar
		arm.toggle_shader_revelacao(true)
		# desliga o shader depois de duracao_seg
		get_tree().create_timer(duracao_seg).timeout.connect(
			func(): 
				if is_instance_valid(arm):
					arm.toggle_shader_revelacao(false)
		)
