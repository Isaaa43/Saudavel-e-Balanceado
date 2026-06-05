class_name SistemaAnimacao
extends Node

@export var animation_player: AnimationPlayer

enum Animacao {IDLE, ANDAR, ATACAR}

## Somente para sync
@export var animacao_acontecendo: Animacao : 
	set(_animacao):
		animacao_acontecendo = _animacao
		_update_animacao(_animacao)

var curr_animacao: Animacao

func acao(animacao: Animacao) -> void:
	_update_animacao(animacao)

func _update_animacao(nova_animacao: Animacao) -> void:
	# se eh a mesma, nao toque de novo
	if curr_animacao == nova_animacao: return
	# nao sobre escreve a anim de ataque
	if curr_animacao == Animacao.ATACAR: return
	
	curr_animacao = nova_animacao
	_play_animacao(nova_animacao)

func _play_animacao(animacao: Animacao) -> void:
	match (animacao):
		Animacao.IDLE:
			animation_player.play("IDLE")
		Animacao.ANDAR:
			animation_player.play("Andar")
		Animacao.ATACAR:
			animation_player.play("Ataque")
			await animation_player.animation_finished
			curr_animacao = Animacao.IDLE
