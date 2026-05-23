class_name FeiticoComportamentoProjetilDef
extends FeiticoComportamentoDef

@export_group("Projetil")
@export var velocidade: float 	= 10.0
@export var perfura: bool		= false

@export var efeitos_impacto : Array[FeiticoEfeitoDef] = []

func _criar() -> FeiticoComportamentoProjetil:
	var comportamento := FeiticoComportamentoProjetil.new(duracao_seg)
	
	comportamento.velocidade = velocidade
	comportamento.perfura = perfura
	
	for efeito_def : FeiticoEfeitoDef in efeitos_impacto:
		comportamento.efeitos_impacto.append(efeito_def.criar())
	
	return comportamento
