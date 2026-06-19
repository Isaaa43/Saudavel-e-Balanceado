class_name FeiticoComportamentoProjetilDef
extends FeiticoComportamentoDef

@export_group("Projetil")
@export var velocidade: float 	= 10.0
@export var perfurar: bool		= false

@export var tamanho_raio: float = 0.5

## TODO: Direcao inicial
## direcao mundo, direcao jogador olhando, direcao alvo proximo

@export_flags_3d_physics var mascara_impacto = 1

func _criar() -> FeiticoComportamentoProjetil:
	var comportamento := FeiticoComportamentoProjetil.new(duracao_seg)
	
	comportamento.velocidade = velocidade
	comportamento.perfurar = perfurar
	comportamento.tamanho_raio = tamanho_raio
	
	return comportamento
