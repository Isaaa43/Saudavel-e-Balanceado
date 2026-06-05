class_name FeiticoEfeitoCongelar
extends FeiticoEfeito

func _aplicar(entidade: Entidade) -> void:
	if entidade is Jogador:
		if is_instance_valid(entidade.sistema_movimento):
			var mov: SistemaMovimento = entidade.sistema_movimento
			mov.congelar(valor)
