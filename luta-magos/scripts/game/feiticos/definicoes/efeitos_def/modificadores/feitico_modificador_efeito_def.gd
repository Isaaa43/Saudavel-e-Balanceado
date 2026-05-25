class_name FeiticoModificadorEfeitoDef
extends Resource

# --- Valor ---
@export_group("Valor")
@export var mult_valor: float = 1.0		## multiplica o valor base do efeito
@export var add_valor: float = 0.0		## adiciona ao valor base do efeito

# --- behavior flags ---
#@export var aplicar_ao_criador: bool = false      # hits the caster too
#@export var inverter_efeito: bool = false         # regen becomes drain, etc

func criar() -> FeiticoModificadorEfeito:
	var mod := FeiticoModificadorEfeito.new()
	mod.mult_valor	= mult_valor
	mod.add_valor	= add_valor
	return mod 
