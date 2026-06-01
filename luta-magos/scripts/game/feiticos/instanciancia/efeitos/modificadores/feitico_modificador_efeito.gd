class_name FeiticoModificadorEfeito
extends RefCounted

# --- Valor ---
var mult_valor: float = 1.0		## multiplica o valor base do efeito
var add_valor: float = 0.0		## adiciona ao valor base do efeito

# --- behavior flags ---
#@export var aplicar_ao_criador: bool = false      # hits the caster too
#@export var inverter_efeito: bool = false         # regen becomes drain, etc
