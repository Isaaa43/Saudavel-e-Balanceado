class_name FeiticoModificadorEfeitoDuradouroDef
extends FeiticoModificadorEfeitoDef

# --- Tipo Efeito ---
@export_group("Tipo Efeito")
@export var alterar_tipo_efeito : bool = false
@export var novo_tipo_efeito 	:= FeiticoEfeito.Tipo.INSTANTANEO
@export var cooldown_seg: float = 0.0
@export_subgroup("Duracao (Somente)")
@export var usos: int = 1
@export var duracao_seg: float = 0.0

# --- Tempo ---
@export_group("Tempo")
@export var mult_cooldown: float = 1.0	## 0.5 = dobro
@export var mult_usos: float = 1.0		## multiplica os usos
@export var add_usos: int = 1			## adiciona usos extras

func criar() -> FeiticoModificadorEfeitoDuradouro:
	var mod := FeiticoModificadorEfeitoDuradouro.new()
	mod.alterar_tipo_efeito		= alterar_tipo_efeito
	mod.novo_tipo_efeito		= novo_tipo_efeito
	mod.cooldown				= cooldown_seg
	mod.usos					= usos
	mod.duracao					= duracao_seg
	mod.mult_cooldown			= mult_cooldown
	mod.mult_usos				= mult_usos
	mod.add_usos				= add_usos
	return mod 

#func set_duracao(duracao_seg: float, _cooldown_seg: float = 1.0) -> void:
	#infinito = false
	#cooldown_seg = _cooldown_seg
	## calcula usos
	#usos = int(duracao_seg / _cooldown_seg)
