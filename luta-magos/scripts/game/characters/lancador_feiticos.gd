class_name LancadorFeiticos
extends Node3D

@export var spell_registry: RegistroFeiticos

@onready var ray_cast_visao: RayCast3D = $RayCast3D

var _cooldowns: Dictionary = {}

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("acao"):
		_lancar_feitico_escolhido("BolaFogo")
	if Input.is_action_just_pressed("acao_2"):
		_lancar_feitico_escolhido("FuraSapato")

func _process(delta: float) -> void:
	for id in _cooldowns:
		_cooldowns[id] = maxf(0.0, _cooldowns[id] - delta)

func _lancar_feitico_escolhido(feitico_id: String) -> void:
	if _cooldowns.get(feitico_id, 0) > 0.1: return
	
	var feitico_def : FeiticoDefinicaoRes = spell_registry.get_feitico(feitico_id)
	
	_cooldowns[feitico_id] = feitico_def.cooldown
	
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
		Feitico.Tipo.EFEITO:
			pass
	
	lancar_feitico(feitico_contexto)

# Main entry point — call this locally AND replicate over network
func lancar_feitico(feitico_contexto : FeiticoContexto) -> void:
	NetworkClient.lancar_feitico(feitico_contexto)
