class_name FeiticoComportamentoProjetilDef
extends FeiticoComportamentoDef

@export_group("Projetil")
@export var velocidade: float 	= 10.0
@export var perfura: bool		= false

func criar() -> FeiticoComportamentoProjetil:
	var comportamento := FeiticoComportamentoProjetil.new(duracao_seg)
	comportamento.tipo = Feitico.Tipo.PROJETIL
	
	comportamento.velocidade = velocidade
	comportamento.perfura = perfura
	
	return comportamento
