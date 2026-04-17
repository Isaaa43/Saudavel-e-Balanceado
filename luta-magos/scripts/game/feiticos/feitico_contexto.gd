class_name FeiticoContexto
extends RefCounted

var feitico_id : String 	= ""
var feitico_tipo 			:= Feitico.Tipo.INSTANTANEO

var criador : int 			= -1
var alvo : Node 			= null

var posicao_global_inicial 	:= Vector3.ZERO
var direcao 				:= Vector3.ZERO

func to_dict() -> Dictionary:
	return {
		"feitico_id" : feitico_id,
		"feitico_tipo" : feitico_tipo,
		"criador" : criador,
		"alvo" : alvo,
		"posicao_global_inicial" : posicao_global_inicial,
		"direcao" : direcao,
	}

static func from_dict(dict : Dictionary) -> FeiticoContexto:
	var feitico_contexto := FeiticoContexto.new()
	feitico_contexto.feitico_id = dict.get("feitico_id")
	feitico_contexto.feitico_tipo = dict.get("feitico_tipo")
	feitico_contexto.criador = dict.get("criador")
	feitico_contexto.alvo = dict.get("alvo")
	feitico_contexto.posicao_global_inicial = dict.get("posicao_global_inicial")
	feitico_contexto.direcao = dict.get("direcao")
	return feitico_contexto
