class_name FeiticoComportamentoArmadilhaDef
extends FeiticoComportamentoDef

@export_group("Armadilha")
## Tempo em segundos para reativar o feitico.
## 		Valores menores que 0.1 nao sao ativados
@export var reativacao_seg: float

func _criar() -> FeiticoComportamentoArmadilha:
	var comportamento := FeiticoComportamentoArmadilha.new(duracao_seg)
	
	return comportamento
