class_name SistemaMana
extends Node

## Quando ocorre mudanca na mana, com porcentagem total da mana maxima [0.0, 1.0] 
signal mudanca_mana(mana_porcentagem: float)

var mana : float
@export var mana_max : float = 100
@onready var mana_max_inverso : float = 1 / mana_max

@export var sistema_efeitos_feiticos: SistemaEfeitosFeiticos
@export var efeito_regen_mana_def: FeiticoEfeitoGanharManaDef

func _ready() -> void:
	mana = mana_max
	# cria a regeneracao de mana
	if sistema_efeitos_feiticos:
		_criar_efeito_mana_regen()


# -----------------------------------------------------------------------------
# Regeneracao de Mana
# -----------------------------------------------------------------------------

func _criar_efeito_mana_regen() -> void:
	var efeito_regen := efeito_regen_mana_def.criar()
	sistema_efeitos_feiticos.receber_feitico_efeito(efeito_regen)

# -----------------------------------------------------------------------------
# Mudar Mana
# -----------------------------------------------------------------------------
func tem_mana_suficiente(_mana_gastar: float) -> bool:
	return mana >= _mana_gastar

func gastar_mana(_mana_gastar: float) -> void:
	if not tem_mana_suficiente(_mana_gastar): return
	# tirar a mana, ate minimo de 0
	mana = max(0, mana - _mana_gastar)
	# emite sinal para atualizar a porcentagem de mana
	_emitir_mana_porcentagem()

func ganhar_mana(_mana_ganha: float) -> void:
	if is_equal_approx(mana, mana_max) or mana > mana_max: return
	
	# adicionar mana ate maximo de mana_max
	mana = min(mana_max, mana + _mana_ganha)
	# emite sinal para atualizar a porcentagem de mana
	_emitir_mana_porcentagem()

func get_mana_previsao_porcent(_mana_gastar: float) -> float:
	return _calc_porcentegem_mana(mana - _mana_gastar)

# -----------------------------------------------------------------------------
# Emitir sinais

## Emite sinal para atualizar a porcentagem de vida
func _emitir_mana_porcentagem() -> void:
	var mana_porcentagem : float = _calc_porcentegem_mana(mana)
	mudanca_mana.emit(mana_porcentagem)

func _calc_porcentegem_mana(_mana: float) -> float:
	return _mana * mana_max_inverso
