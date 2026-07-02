class_name SistemaAnimacao
extends Node

@export var animation_player: AnimationPlayer

enum AnimacaoFlags {
	IDLE = 1,       # 0001
	ANDANDO = 2,    # 0010
	PULANDO = 4,    # 0100
	ATACANDO = 8,   # 1000
}
var esta_idle		: bool = true
var esta_andando	: bool = false
var esta_pulando	: bool = false
var esta_atacando	: bool = false

## Somente para sync
@export var synced_animacao: int : 
	set(_animacao):
		# se mudou
		if synced_animacao != _animacao:
			synced_animacao = _animacao
			# so executa se n for o dono (eh o jogador online)
			if not is_multiplayer_authority():
				_update_animacao(_animacao)

@onready var animation_tree_movimento: AnimationTree = $AnimationTreeMovimento

func _ready() -> void:
	animation_tree_movimento.active = true
	animation_tree_movimento.anim_player = animation_player.get_path()
	# so for o jogador online)
	if not is_multiplayer_authority():
		set_physics_process(false)

## Pausa e toca a animacao atual [br]
## [code]True[/code] para pausar a animacao [br]
## [code]False[/code] para voltar a tocar a animacao
func toggle_pausar(pausar: bool) -> void:
	if pausar:
		animation_tree_movimento.active = false
		animation_player.pause()
	else:
		animation_tree_movimento.active = true


func _physics_process(_delta: float) -> void:
	esta_idle = not (esta_andando or esta_pulando)
	# atualiza
	synced_animacao = _flags_to_int(esta_idle, esta_andando, esta_pulando, esta_atacando)
	_update_animacao(synced_animacao)

func _update_animacao(animacao_flags: int) -> void:
	_int_to_flags(animacao_flags)
	animation_tree_movimento.set("parameters/Movimentacao/conditions/idle", 	esta_idle)
	animation_tree_movimento.set("parameters/Movimentacao/conditions/andando", 	esta_andando)
	animation_tree_movimento.set("parameters/Movimentacao/conditions/pulando", 	esta_pulando)
	animation_tree_movimento.set("parameters/conditions/atacando", 				esta_atacando)
	esta_atacando = false


func set_esta_chao(esta_chao: bool) -> void:
	esta_pulando = not esta_chao

func set_esta_movendo(esta_movendo: bool) -> void:
	esta_andando = esta_movendo

func atacar() -> void:
	esta_atacando = true
	synced_animacao = _flags_to_int(esta_idle, esta_andando, esta_pulando, esta_atacando)

func _flags_to_int(idle: bool, andando: bool, pulando: bool, atacando: bool) -> int:
	var flags : int = 0
	if idle:
		flags |= AnimacaoFlags.IDLE
	if andando:
		flags |= AnimacaoFlags.ANDANDO
	if pulando:
		flags |= AnimacaoFlags.PULANDO
	if atacando:
		flags |= AnimacaoFlags.ATACANDO
	
	return flags

func _int_to_flags(flags: int) -> void:
	esta_idle		= (flags & AnimacaoFlags.IDLE) 		!= 0
	esta_andando	= (flags & AnimacaoFlags.ANDANDO) 	!= 0
	esta_pulando	= (flags & AnimacaoFlags.PULANDO) 	!= 0
	esta_atacando	= (flags & AnimacaoFlags.ATACANDO) 	!= 0
