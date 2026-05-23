class_name FeiticoDef
extends Resource

@export_group("ID")
@export var feitico_id: String = ""

@export_group("Info")
@export var nome: String = ""
@export var tipo : Feitico.Tipo = Feitico.Tipo.PROJETIL
@export var espaco : Feitico.Espaco = Feitico.Espaco.DECK
@export_multiline() var descricao : String = ""

@export_group("Stats")
@export var cooldown: float = 1.0
@export var custo: float = 10.0

@export_group("Visual")
@export var icone_hud: Texture2D

@export_group("Comportamento")
@export var comportamento_def: FeiticoComportamentoDef


#TODO: lista de efeitos

func criar_feitico() -> Feitico:
	var feitico := Feitico.new()
	
	feitico.feitico_id = feitico_id
	feitico.nome = nome
	feitico.tipo = tipo
	feitico.espaco = espaco
	
	# Cria os sub sistemas do feitico
	feitico.comportamento = comportamento_def.criar()
	
	return feitico
