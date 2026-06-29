class_name FeiticoComportamentoSomenteEfeitoDef
extends FeiticoComportamentoDef

@export_group("Somente Efeito")

## Tempo em que a area de efeito existe (para aplicar efeito nos corpos que entrarem na area)
@export var duracao_aplicacao_efeito_seg : float = 0.1

func _criar() -> FeiticoComportamentoSomenteEfeito:
	var comportamento := FeiticoComportamentoSomenteEfeito.new(duracao_seg)
	comportamento.duracao_aplicacao_efeito_seg = duracao_aplicacao_efeito_seg
	
	return comportamento
