# Resource usado para armazenar os dados de um feitico.
class_name FeiticoDef
extends Resource

@export_group("ID")
## Identificador unico de cada feitico
@export var feitico_id: String = ""

@export_group("Info")
## Nome exibido da carta
@export var nome: String = ""
## Tipo do feitico
@export var tipo : Feitico.Tipo = Feitico.Tipo.PROJETIL
## Espaco que o feitico ocupa
@export var espaco : Feitico.Espaco = Feitico.Espaco.SUPORTE
## Texto descritivo da carta
@export_multiline() var descricao : String = ""

@export_group("Stats")
## Tempo minimo em segundo para lancar outro feitico igual
@export var cooldown: float = 1.0
## Custo de mana para ativar a carta
@export var custo: float = 10.0

@export_group("Visual")
## Icone a ser exibido na interface de selecao do deck
@export var icone_hud: Texture2D

@export_group("Comportamento")
@export var comportamento_def: FeiticoComportamentoDef


#TODO: lista de efeitos

func criar_feitico(contexto: FeiticoContexto) -> Feitico:
	var feitico := Feitico.new()
	
	feitico.feitico_id = feitico_id
	feitico.nome = nome
	feitico.tipo = tipo
	feitico.espaco = espaco
	
	feitico.contexto = contexto
	assert(feitico_id == contexto.feitico_id, "Feitico_id diferentes no feitico e contexto")
	
	# Cria os sub sistemas do feitico
	feitico.comportamento = comportamento_def.criar(contexto)
	feitico.comportamento.set_feitico_tipo(tipo)
	
	return feitico
