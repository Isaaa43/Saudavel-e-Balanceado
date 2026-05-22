class_name FeiticoComportamentoEfeitoDef
extends FeiticoComportamentoDef

@export_group("Efeito")

func criar() -> FeiticoComportamentoEfeito:
	var comportamento := FeiticoComportamentoEfeito.new()
	comportamento.tipo = Feitico.Tipo.EFEITO
	
	return comportamento
