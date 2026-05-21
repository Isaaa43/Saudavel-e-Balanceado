class_name FeiticoDef
extends Resource

@export_group("ID")
@export var feitico_id: String = ""

@export_group("Info")
@export var nome: String = ""
@export var tipo : Feitico.Tipo = Feitico.Tipo.PROJETIL
@export var espaco : Feitico.Espaco = Feitico.Espaco.DECK
@export var descricao : String = ""

@export_group("Status")
@export var cooldown: float = 1.0
@export var custo: float = 10.0

@export_group("Visual")
@export var icone_hud: Texture2D
@export var feitico_scene: PackedScene

#TODO: lista de efeitos
