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

var efeitos : Array[FeiticoEfeito] = []

var comportamento: FeiticoComportamento
var corpo: FeiticoCorpo
var visual: FeiticoVisual

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
	# Visual 
	visual.name = "Visual"
	add_child(visual, true)
	# Comportamento
	comportamento.name = "Comportamento"
	comportamento.corpo = corpo
	comportamento.acabou.connect(destruir)
	add_child(comportamento, true)
	# Corpo
	corpo.name = "Corpo"
	add_child(corpo, true)
	corpo.global_position = posicao_global_inicial
	corpo.set_visual_transform(visual.visual_3d)

## Lanca a magia
func lancar() -> void:
	if visual.particulas:
		visual.particulas.emitting = true

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
