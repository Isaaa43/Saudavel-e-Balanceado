class_name FeiticoComportamentoProjetilDef
extends FeiticoComportamentoDef

@export_group("Projetil")
@export var velocidade: float 	= 10.0
@export var perfurar: bool		= false

@export_flags_3d_physics var mascara_impacto = 1

func _criar() -> FeiticoComportamentoProjetil:
	var comportamento := FeiticoComportamentoProjetil.new(duracao_seg)
	
	comportamento.velocidade = velocidade
	comportamento.perfurar = perfurar
	
	return comportamento
