class_name Feitico
extends Node

var feitico_id : String = ""
var nome: String = ""
var tipo : Tipo = Tipo.PROJETIL
var espaco : Espaco = Espaco.SUPORTE

var comportamento: FeiticoComportamento

var contexto: FeiticoContexto


enum Tipo {
	PROJETIL,		## Se move pelo cenario
	POSICIONADO,	## Fica parado no mapa
	EFEITO			## Apenas os efeitos, sem presenca fisica
}

enum Lancamento {
	DISPARO,	## Clique
	CANALIZAR	## Segurar
}

enum Espaco {
	DANO,		## Retiram vida do jogador
	SUPORTE,	## Ajudam o jogador
	REVELACAO	## Revelam
}

## Cria a magia, antes de lancar
func criar() -> void:
	# TODO: remover o force_readable_name
	# Comportamento
	comportamento.contexto = contexto
	comportamento.name = "Comportamento"
	comportamento.acabou.connect(destruir)
	add_child(comportamento, true)

## Lanca a magia
func lancar() -> void:
	comportamento.iniciar()

## Ao colidir com objetos
func colidir() -> void:
	pass

## Ao acertar um objeto
func acertar() -> void:
	pass

## Aplicar os efeitos do feitico no alvo
func aplicar_efeito() -> void:
	pass

func destruir() -> void:
	queue_free()
