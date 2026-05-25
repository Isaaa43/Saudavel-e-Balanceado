class_name FeiticoEfeitoDuradouroRegenManaDef
extends FeiticoEfeitoDef

@export_group("Mana Regen")
@export var qntd_mana: float = 0.0
@export var cooldown_seg: float = 1.0

func _criar() -> FeiticoEfeitoDuradouroRegenMana:
	var efeito := FeiticoEfeitoDuradouroRegenMana.new()
	efeito.qntd_mana = qntd_mana
	efeito.cooldown_seg = cooldown_seg
	return efeito
