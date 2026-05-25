class_name FeiticoModificadorEfeitoDef
extends Resource

# --- Tipo Efeito ---
@export var alterar_tipo_efeito : bool = false
@export var aplicar_tipo_efeito := FeiticoEfeito.Tipo.DURACAO
@export var cooldown: float = 0.0
@export var usos: int = 1

# --- Tempo ---
@export var mult_cooldown: float = 1.0	## 0.5 = dobro
@export var mult_usos: float = 1.0		## multiplica os usos
@export var add_usos: int = 1			## adiciona usos extras

# --- Valor ---
@export var mult_valor: float = 1.0		## multiplica o valor base do efeito
@export var add_valor: float = 0.0		## adiciona ao valor base do efeito

# --- behavior flags ---
#@export var aplicar_ao_criador: bool = false      # hits the caster too
#@export var inverter_efeito: bool = false         # regen becomes drain, etc
