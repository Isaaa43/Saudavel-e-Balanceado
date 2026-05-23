class_name FeiticoComportamentoSomenteEfeitoDef
extends FeiticoComportamentoDef

@export_group("Somente Efeito")

@export var efeitos : Array[FeiticoEfeitoDef] = []

func criar() -> FeiticoComportamentoSomenteEfeito:
	var comportamento := FeiticoComportamentoSomenteEfeito.new(duracao_seg)
	comportamento.tipo = Feitico.Tipo.EFEITO
	
	for efeito_def : FeiticoEfeitoDef in efeitos:
		comportamento.efeitos.append(efeito_def.criar())
	
	return comportamento
