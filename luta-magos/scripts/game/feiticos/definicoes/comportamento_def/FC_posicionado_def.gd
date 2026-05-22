class_name FeiticoComportamentoPosicionadoDef
extends FeiticoComportamentoDef

@export_group("Posicionado")
## Tempo em segundos para reativar o feitico.
## 		Valores menores que 0.1 nao sao ativados
@export var reativacao_seg: float

func criar() -> FeiticoComportamentoPosicionado:
	var comportamento := FeiticoComportamentoPosicionado.new()
	comportamento.tipo = Feitico.Tipo.POSICIONADO
	
	return comportamento
