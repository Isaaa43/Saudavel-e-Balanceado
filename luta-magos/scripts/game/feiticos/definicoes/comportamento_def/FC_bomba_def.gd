class_name FeiticoComportamentoBombaDef
extends FeiticoComportamentoDef

@export_group("Bomba")
@export var velocidade: float 	= 10.0

@export var tamanho_raio: float = 0.5

@export_flags_3d_physics var mascara_impacto = 1

func _criar() -> FeiticoComportamentoBomba:
	var comportamento := FeiticoComportamentoBomba.new(duracao_seg)
	
	comportamento.velocidade = velocidade
	comportamento.tamanho_raio = tamanho_raio
	
	return comportamento
