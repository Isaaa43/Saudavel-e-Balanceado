class_name FeiticoComportamentoPosicionadoDef
extends FeiticoComportamentoDef

@export_group("Posicionado")
## Tempo em segundos para reativar o feitico.
## 		Valores menores que 0.1 nao sao ativados
@export var reativacao_seg: float

@export var efeitos_ativacao : Array[FeiticoEfeitoDef] = []

func criar() -> FeiticoComportamentoPosicionado:
	var comportamento := FeiticoComportamentoPosicionado.new(duracao_seg)
	comportamento.tipo = Feitico.Tipo.POSICIONADO
	
	for efeito_def : FeiticoEfeitoDef in efeitos_ativacao:
		comportamento.efeitos_ativacao.append(efeito_def.criar())
	
	return comportamento
