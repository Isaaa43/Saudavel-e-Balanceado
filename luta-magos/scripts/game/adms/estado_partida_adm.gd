class_name EstadoPartidaAdm
extends Node

signal estado_atualizado(estado_partida: EstadoPartida)

enum EstadoPartida {NAO_INICIADA, ROLANDO, FIM_TEMPO, FIM_PARTIDA}

## Nao deve ser alterado
@export var estado_partida: EstadoPartida :
	set(_estado):
		_update_estado_partida(_estado)
		estado_partida = _estado

func set_nao_iniciada() -> void:
	estado_partida = EstadoPartida.NAO_INICIADA

func set_rolando() -> void:
	estado_partida = EstadoPartida.ROLANDO

func set_fim_tempo() -> void:
	estado_partida = EstadoPartida.FIM_TEMPO

func set_fim_partida() -> void:
	estado_partida = EstadoPartida.FIM_PARTIDA


func _update_estado_partida(novo_estado: EstadoPartida) -> void:
	# se nao foi alterado, pare
	if estado_partida == novo_estado: return
	# emita um sinal com o novo estado
	estado_atualizado.emit(novo_estado)
