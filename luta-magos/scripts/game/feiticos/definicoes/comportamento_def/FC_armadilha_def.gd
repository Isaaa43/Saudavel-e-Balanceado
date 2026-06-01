class_name FeiticoComportamentoArmadilhaDef
extends FeiticoComportamentoDef

@export_group("Armadilha")
## Tempo em segundos para reativar o feitico.
## 		Valores menores que 0.1 nao sao ativados
@export var reativacao_seg: float

@export var comportamento_ativacao_def : FeiticoComportamentoDef

func _criar() -> FeiticoComportamentoArmadilha:
	var comportamento := FeiticoComportamentoArmadilha.new(duracao_seg)
	comportamento.reativacao_seg = reativacao_seg
	# TODO: verificar
	if comportamento_ativacao_def:
		comportamento.comportamento_ativacao_def = comportamento_ativacao_def
	return comportamento
