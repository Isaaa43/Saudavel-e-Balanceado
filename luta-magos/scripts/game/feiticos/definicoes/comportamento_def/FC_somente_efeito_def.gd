class_name FeiticoComportamentoSomenteEfeitoDef
extends FeiticoComportamentoDef

@export_group("Somente Efeito")

func _criar() -> FeiticoComportamentoSomenteEfeito:
	var comportamento := FeiticoComportamentoSomenteEfeito.new(duracao_seg)
	
	return comportamento
