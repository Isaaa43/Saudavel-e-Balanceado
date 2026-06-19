class_name SistemaAnimacao
extends Node

@export var animation_player: AnimationPlayer

enum Animacao {IDLE, ANDAR, ATACAR, PULAR}

## Somente para sync
@export var synced_animacao: Animacao : 
	set(_animacao):
		if synced_animacao != _animacao:
			synced_animacao = _animacao
			# so executa se n for o dono
			if not is_multiplayer_authority():
				_update_animacao(_animacao)

var curr_animacao: Animacao


func acao(animacao: Animacao) -> void:
	_update_animacao(animacao)

func _update_animacao(nova_animacao: Animacao) -> void:	
	# se eh a mesma, nao toque de novo
	if curr_animacao == nova_animacao: return
	# nao sobre escreve a anim de ataque
	if curr_animacao == Animacao.ATACAR: return
	if curr_animacao == Animacao.PULAR: return
	
	_play_animacao(nova_animacao)

func _play_animacao(animacao: Animacao) -> void:
	curr_animacao = animacao
	
	# Se for o dono, atualiza a variavel de sync
	if is_multiplayer_authority():
		synced_animacao = animacao
	
	# play animacao
	match (animacao):
		Animacao.IDLE:
			animation_player.play("IDLE")
		Animacao.ANDAR:
			animation_player.play("Andar")
		Animacao.PULAR:
			animation_player.play("Pular")
			await animation_player.animation_finished
			_play_animacao(Animacao.IDLE)
		Animacao.ATACAR:
			animation_player.play("Ataque")
			await animation_player.animation_finished
			_play_animacao(Animacao.IDLE)
