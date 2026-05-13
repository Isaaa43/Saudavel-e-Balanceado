class_name SistemaMana
extends Node

## Quando ocorre mudanca na mana, com porcentagem total da mana maxima [0.0, 1.0] 
signal mudanca_mana(mana_porcentagem: float)

var mana : float
@export var mana_max : float = 100
@onready var mana_max_inverso : float = 1 / mana_max

## Quantidade de mana regenerada por segundo
@export var mana_regen_seg : float = 1.5
var tempo_regen : float = 1.0

func _ready() -> void:
	mana = mana_max

func tem_mana_suficiente(_mana_gastar: float) -> bool:
	return mana >= _mana_gastar

# -----------------------------------------------------------------------------
# Regeneracao de Mana
# -----------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	if tempo_regen <= 0.0: 
		tempo_regen += 1.0
		_regen_mana()
	
	tempo_regen -= delta

func _regen_mana() -> void:
	if is_equal_approx(mana, mana_max): return
	
	ganhar_mana(mana_regen_seg)

# -----------------------------------------------------------------------------
# Mudar Mana
# -----------------------------------------------------------------------------
func gastar_mana(_mana_gastar: float) -> void:
	if not tem_mana_suficiente(_mana_gastar): return
	
	print('gastar_mana %d' % _mana_gastar)
	
	# tirar a mana, ate minimo de 0
	mana = max(0, mana - _mana_gastar)
	# emite sinal para atualizar a porcentagem de mana
	_emitir_mana_porcentagem()

func ganhar_mana(_mana_ganha: float) -> void:
	print('ganhar_mana %d' % _mana_ganha)
	
	# adicionar mana ate maximo de mana_max
	mana = min(mana_max, mana + _mana_ganha)
	# emite sinal para atualizar a porcentagem de mana
	_emitir_mana_porcentagem()

# -----------------------------------------------------------------------------
# Emitir sinais

## Emite sinal para atualizar a porcentagem de vida
func _emitir_mana_porcentagem() -> void:
	var mana_porcentagem : float = mana * mana_max_inverso
	mudanca_mana.emit(mana_porcentagem)
