class_name LancadorFeiticos
extends Node3D

@export var sistema_mana : SistemaMana

@onready var registro_feiticos: RegistroFeiticos = Registros.reg_feiticos

@onready var ray_cast_visao: RayCast3D = $RayCast3D
# TODO: temp
var hud_jogador: HUDJogador

var _cooldowns: Dictionary = {}

var selecao_feitico_id: int = 0

func _input(_event: InputEvent) -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE: return
	
	if _event is InputEventKey and _event.pressed:
		match (_event.keycode):
			KEY_1:
				_selecionar(0)
			KEY_2:
				_selecionar(1)
			KEY_3:
				_selecionar(2)
			KEY_4:
				_selecionar(3)
			KEY_5:
				_selecionar(4)
	
	if Input.is_action_just_pressed("acao"):
		_escolher_feitico()

func _selecionar(id: int) -> void:
	selecao_feitico_id = id
	hud_jogador.selecionar_magia(id)

func _escolher_feitico() -> void:
	match selecao_feitico_id:
		0:
			lancar_feitico_escolhido("BolaFogo")
		1:
			lancar_feitico_escolhido("FuraSapato")
		2:
			lancar_feitico_escolhido("PuloImpulsionado")
		3:
			lancar_feitico_escolhido("Ozempagic")
		4:
			lancar_feitico_escolhido("ToTeVendo")

func _process(delta: float) -> void:
	for id in _cooldowns:
		_cooldowns[id] = maxf(0.0, _cooldowns[id] - delta)

func lancar_feitico_escolhido(feitico_id: String) -> void:
	# se estiver no cooldown, nao continue
	if _cooldowns.get(feitico_id, 0) > 0.1: return
	
	# pega as definicoes do feitico
	var feitico_def : FeiticoDefinicaoRes = registro_feiticos.get_feitico(feitico_id)
	# verifica se tem mana o suficiente para criar o feitico
	if not sistema_mana.tem_mana_suficiente(feitico_def.custo): return
	
	# cria o contexto do feitico
	var feitico_contexto : FeiticoContexto = _criar_feitico_contexto(feitico_def)
	# se nao foi possivel criar o contexto (ou lancar o feitico) pare
	if not feitico_contexto: return
	
	# coloque o feitico no cooldown
	_cooldowns[feitico_id] = feitico_def.cooldown
	# gasta a amana
	sistema_mana.gastar_mana(feitico_def.custo)
	
	# lancar o feitico
	_lancar_feitico(feitico_contexto)

func _criar_feitico_contexto(feitico_def : FeiticoDefinicaoRes) -> FeiticoContexto:
	var feitico_contexto := FeiticoContexto.new()
	
	feitico_contexto.feitico_id = feitico_def.feitico_id
	feitico_contexto.feitico_tipo = feitico_def.feitico_tipo
	# TODO: achar outra solucao alem do peer id
	feitico_contexto.criador = multiplayer.get_unique_id()
	feitico_contexto.alvo = null
	feitico_contexto.posicao_global_inicial = global_position
	feitico_contexto.direcao = -get_global_transform().basis.z
	
	# TODO: mudar o contexto dependendo do tipo de feitico
	match (feitico_def.feitico_tipo):
		Feitico.Tipo.INSTANTANEO:
			pass
		Feitico.Tipo.POSICIONADO:
			ray_cast_visao.force_raycast_update()
			if ray_cast_visao.is_colliding():
				var posicao := ray_cast_visao.get_collision_point()
				feitico_contexto.posicao_global_inicial = posicao
				feitico_contexto.direcao = Vector3.FORWARD
			else:
				# se nao for possivel colocar, entao nao lance
				return null
		Feitico.Tipo.EFEITO:
			feitico_contexto.posicao_global_inicial = global_position
	
	return feitico_contexto

# chama o network para enviar o feitico
func _lancar_feitico(feitico_contexto : FeiticoContexto) -> void:
	Network.client.lancar_feitico(feitico_contexto)
