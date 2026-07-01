class_name FeiticoComportamentoSomenteEfeito
extends FeiticoComportamento

var duracao_aplicacao_efeito_seg: float 

func iniciar_comportamento() -> void:
	await get_tree().create_timer(duracao_aplicacao_efeito_seg).timeout
	area_ativacao.body_entered.disconnect(_entrou_area_aplicar_efeitos)

func physics_process(delta: float) -> void:
	pass
