class_name SistemaVida
extends Node

## Quando ocorre mudanca na vida, com porcentagem total da vida maxima [0.0, 1.0] 
signal mudanca_vida(vida_porcentagem: float)
signal levou_dano(dano: float)
signal morreu

var esta_vivo: bool = true

var vida : float
@export var vida_max : float = 150
@onready var vida_max_inverso : float = 1 / vida_max

func _ready() -> void:
	vida = vida_max

# -----------------------------------------------------------------------------
# Mudar vida
# -----------------------------------------------------------------------------
func receber_dano(_dano: float) -> void:
	# tirar o dano do jogador, ate minimo de 0
	vida = max(0, vida - _dano)
	# emite sinal para atualizar a porcentagem de vida
	_emitir_vida_porcentagem()
	# emite que levou dano
	levou_dano.emit(_dano)
	
	# verificar se morreu
	_verificar_morte()

func receber_vida(_vida: float) -> void:
	# adicionar vida do jogador, ate maximo de vida_max
	vida = min(vida_max, vida + _vida)
	# emite sinal para atualizar a porcentagem de vida
	_emitir_vida_porcentagem()

# -----------------------------------------------------------------------------
# Emitir sinais

## Emite sinal para atualizar a porcentagem de vida
func _emitir_vida_porcentagem() -> void:
	var vida_porcent : float = vida * vida_max_inverso
	mudanca_vida.emit(vida_porcent)

# -----------------------------------------------------------------------------
# Morte
# -----------------------------------------------------------------------------
func _verificar_morte() -> void:
	if vida == 0:
		morrer()

func morrer() -> void:
	# se ja estiver morto, pare
	if not esta_vivo: return
	esta_vivo = false
	# emite que morreu
	morreu.emit()
