class_name FeiticoContexto
extends RefCounted

var feitico_id : String 	= ""

var criador : int 			= -1
var alvo : Node 			= null

var posicao_global_inicial 	:= Vector3.ZERO
var direcao 				:= Vector3.ZERO

func to_dict() -> Dictionary:
	return {
		"feitico_id" : feitico_id,
		"criador" : criador,
		"alvo" : alvo,
		"posicao_global_inicial" : posicao_global_inicial,
		"direcao" : direcao,
	}

static func from_dict(dict : Dictionary) -> FeiticoContexto:
	var feitico_contexto := FeiticoContexto.new()
	feitico_contexto.feitico_id = dict.get("feitico_id")
	feitico_contexto.criador = dict.get("criador")
	feitico_contexto.alvo = dict.get("alvo")
	feitico_contexto.posicao_global_inicial = dict.get("posicao_global_inicial")
	feitico_contexto.direcao = dict.get("direcao")
	return feitico_contexto

static func criar(
	feitico_def: FeiticoDef,
	lancador_feiticos: LancadorFeiticos,
	criador_id: int
) -> FeiticoContexto:
	
	var feitico_contexto := FeiticoContexto.new()
	
	feitico_contexto.feitico_id = feitico_def.feitico_id
	# TODO: achar outra solucao alem do peer id
	feitico_contexto.criador = criador_id
	feitico_contexto.alvo = null
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

func aplicar_contexto(feitico: Feitico) -> void:
	# se nao for o mesmo id, do feitico e do contexto, pare
	if feitico.feitico_id != feitico_id: return
	
	#feitico.criador = criador
	#feitico.alvo = alvo
	feitico.posicao_global_inicial = posicao_global_inicial
	feitico.direcao = direcao
