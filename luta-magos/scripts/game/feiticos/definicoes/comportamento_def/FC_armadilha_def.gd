class_name FeiticoComportamentoArmadilhaDef
extends FeiticoComportamentoDef

@export_group("Armadilha")
## Tempo em segundos para reativar o feitico.
## 		Valores menores que 0.1 nao sao ativados
@export var reativacao_seg: float

@export var efeitos_ativacao : Array[FeiticoEfeitoDef] = []

func criar() -> FeiticoComportamentoArmadilha:
	var comportamento := FeiticoComportamentoArmadilha.new(duracao_seg)
	comportamento.tipo = Feitico.Tipo.POSICIONADO
	
	for efeito_def : FeiticoEfeitoDef in efeitos_ativacao:
		comportamento.efeitos_ativacao.append(efeito_def.criar())
	
	return comportamento
