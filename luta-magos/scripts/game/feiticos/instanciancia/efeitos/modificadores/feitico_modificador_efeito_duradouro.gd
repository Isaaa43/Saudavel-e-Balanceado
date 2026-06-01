class_name FeiticoModificadorEfeitoDuradouro
extends FeiticoModificadorEfeito

# --- Tipo Efeito ---
var alterar_tipo_efeito : bool = false
var novo_tipo_efeito 	:= FeiticoEfeito.Tipo.INSTANTANEO
var cooldown: float = 0.0
var usos: int = 1
var duracao: float = 0.0

# --- Tempo ---
var mult_cooldown: float = 1.0	## 0.5 = dobro
var mult_usos: float = 1.0		## multiplica os usos
var add_usos: int = 1			## adiciona usos extras
