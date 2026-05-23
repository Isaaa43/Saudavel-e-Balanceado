class_name Feitico
extends Node

var feitico_id : String = ""
var nome: String = ""
var tipo : Tipo = Tipo.PROJETIL
var espaco : Espaco = Espaco.DECK

var criador : Jogador = null
var alvo : Node = null

var posicao_global_inicial := Vector3.ZERO
var direcao := Vector3.ZERO : 
	set(_direcao):
		direcao = _direcao
		comportamento.direcao = direcao

var comportamento: FeiticoComportamento

enum Tipo {
	PROJETIL,
	POSICIONADO,
	EFEITO
}

enum Espaco {
	DECK,
	PASSIVA
}

## Cria a magia, antes de lancar
func criar() -> void:
	# TODO: remover o force_readable_name
	# Comportamento
	comportamento.name = "Comportamento"
	comportamento.acabou.connect(destruir)
	add_child(comportamento, true)

## Lanca a magia
func lancar() -> void:
	comportamento.iniciar(posicao_global_inicial)

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
