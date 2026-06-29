class_name FeiticoEfeitoMudarVelocidade
extends FeiticoEfeito

var duracao_seg: float

func _aplicar(entidade: Entidade) -> void:
	if entidade is Jogador:
		if is_instance_valid(entidade.sistema_movimento):
			var mov: SistemaMovimento = entidade.sistema_movimento
			mov.mudar_velocidade(valor, duracao_seg)
