class_name FeiticoComportamentoPosicionado
extends FeiticoComportamento

## Tempo em segundos para reativar o feitico.
## 		Valores menores que 0.1 nao sao ativados
var reativacao_seg: float

var efeitos_ativacao : Array[FeiticoEfeito] = []

func physics_process(delta: float) -> void:
	pass

func aplicar_efeitos(jogador: Jogador) -> void:
	for efeito : FeiticoEfeito in efeitos_ativacao:
		efeito.aplicar(jogador)
