class_name SistemaEfeitosFeiticos
extends Node

@export var jogador: Jogador

func receber_feitico_efeito(feitico_efeito: FeiticoEfeito) -> void:
	feitico_efeito.aplicar(jogador)
