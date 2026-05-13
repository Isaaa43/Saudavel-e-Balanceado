class_name FeiticoDefinicaoRes
extends Resource

@export var feitico_id: String = ""

@export var nome: String = ""
@export var feitico_tipo : Feitico.Tipo = Feitico.Tipo.INSTANTANEO
@export var cooldown: float = 1.0
@export var custo: float = 10.0

@export var feitico_scene: PackedScene

#TODO: lista de efeitos
