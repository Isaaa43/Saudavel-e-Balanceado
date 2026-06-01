class_name FeiticoContexto
extends RefCounted

var feitico_id : String 	= ""

var criador_id : int 	= -1
var alvo_id : int 		= -1

var posicao_global_inicial 	:= Vector3.ZERO
var direcao 				:= Vector3.ZERO

func to_dict() -> Dictionary:
	return {
		"feitico_id" : feitico_id,
		"criador_id" : criador_id,
		"alvo_id" : alvo_id,
		"posicao_global_inicial" : posicao_global_inicial,
		"direcao" : direcao,
	}

static func from_dict(dict : Dictionary) -> FeiticoContexto:
	var feitico_contexto := FeiticoContexto.new()
	feitico_contexto.feitico_id = dict.get("feitico_id")
	feitico_contexto.criador_id = dict.get("criador_id")
	feitico_contexto.alvo_id = dict.get("alvo_id")
	feitico_contexto.posicao_global_inicial = dict.get("posicao_global_inicial")
	feitico_contexto.direcao = dict.get("direcao")
	return feitico_contexto

static func criar(
	feitico_def: FeiticoDef,
	lancador_feiticos: LancadorFeiticos,
) -> FeiticoContexto:
	
	var feitico_contexto := FeiticoContexto.new()
	
	feitico_contexto.feitico_id = feitico_def.feitico_id
	feitico_contexto.criador_id = lancador_feiticos.jogador_id
	# TODO: colocar o alvo
	feitico_contexto.alvo_id = -1
	# TODO: mudar o contexto dependendo do tipo de feitico
	match (feitico_def.tipo):
		Feitico.Tipo.PROJETIL:
			feitico_contexto.posicao_global_inicial = lancador_feiticos.global_position
			feitico_contexto.direcao = lancador_feiticos.get_direcao_mirando()
		Feitico.Tipo.POSICIONADO:
			var pos_global: Vector3 = lancador_feiticos.get_posicao_global_mirando()
			if pos_global != Vector3.INF:
				feitico_contexto.posicao_global_inicial = pos_global
				feitico_contexto.direcao = Vector3.FORWARD
			else:
				# se nao for possivel colocar, entao nao lance
				return null
		Feitico.Tipo.EFEITO:
			feitico_contexto.posicao_global_inicial = lancador_feiticos.global_position
	
	return feitico_contexto
