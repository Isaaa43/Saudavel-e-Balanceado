@abstract
class_name FeiticoEfeitoDef
extends Resource

enum Tipo {
	DANO,
	CURA,
	ESCUDO,
	VELOCIDADE,
}

@abstract
func criar() -> FeiticoEfeito
