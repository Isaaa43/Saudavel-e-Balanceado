class_name FeiticoComportamentoSomenteEfeitoDef
extends FeiticoComportamentoDef

@export_group("Somente Efeito")

@export var efeitos : Array[FeiticoEfeitoDef] = []

func _criar() -> FeiticoComportamentoSomenteEfeito:
	var comportamento := FeiticoComportamentoSomenteEfeito.new(duracao_seg)
	
	for efeito_def : FeiticoEfeitoDef in efeitos:
		comportamento.efeitos.append(efeito_def.criar())
	
	return comportamento
