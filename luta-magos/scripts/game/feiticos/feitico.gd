@abstract
class_name Feitico
extends Node3D

var feitico_id : String = ""
var nome: String = ""
var feitico_tipo : Tipo = Tipo.INSTANTANEO

var criador : Node = null
var alvo : Node = null

var posicao_inicial := Vector3.ZERO
var direcao := Vector3.ZERO

var efeitos : Array[FeiticoEfeito] = []

enum Tipo {
	INSTANTANEO,
	POSICIONADO,
	EFEITO
}

## Cria a magia, antes de lancar
func criar() -> void:
	pass

## Lanca a magia
func lancar() -> void:
	pass

## Ao colidir com objetos
func colidir() -> void:
	pass

## Ao acertar um objeto
func acertar() -> void:
	pass

## Aplicar os efeitos do feitico no alvo
func aplicar_efeito() -> void:
	pass
