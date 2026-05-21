class_name FeiticoComportamentoProjetilDef
extends FeiticoComportamentoDef

@export_group("Projetil")
@export var velocidade: float
@export var perfura: bool

func criar() -> FeiticoComportamentoProjetil:
	var definicao := FeiticoComportamentoProjetil.new()
	return definicao
