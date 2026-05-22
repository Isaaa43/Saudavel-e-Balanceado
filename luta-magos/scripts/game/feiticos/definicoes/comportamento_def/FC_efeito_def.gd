class_name FeiticoComportamentoEfeitoDef
extends FeiticoComportamentoDef

@export_group("Efeito")

@export var efeitos : Array[FeiticoEfeitoDef] = []

func criar() -> FeiticoComportamentoEfeito:
	var comportamento := FeiticoComportamentoEfeito.new(duracao_seg)
	comportamento.tipo = Feitico.Tipo.EFEITO
	
	for efeito_def : FeiticoEfeitoDef in efeitos:
		comportamento.efeitos.append(efeito_def.criar())
	
	return comportamento
