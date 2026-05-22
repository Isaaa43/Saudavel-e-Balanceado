class_name Feitico
extends Node

var feitico_id : String = ""
var nome: String = ""
var tipo : Tipo = Tipo.PROJETIL
var espaco : Espaco = Espaco.DECK

var criador : Jogador = null
var alvo : Node = null

var posicao_global_inicial := Vector3.ZERO
var direcao := Vector3.ZERO

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
	corpo.global_position = posicao_global_inicial
	corpo.set_visual_transform(visual.visual_3d)

## Lanca a magia
func lancar() -> void:
	criar()

## Ao colidir com objetos
func colidir() -> void:
	pass

## Ao acertar um objeto
func acertar() -> void:
	pass

## Aplicar os efeitos do feitico no alvo
func aplicar_efeito() -> void:
	pass
