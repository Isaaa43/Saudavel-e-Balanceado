class_name LancadorFeiticos
extends Node3D

signal lancar_feitico(feitico_contexto: FeiticoContexto)

@export var sistema_mana : SistemaMana
@export var audio_cast : AudioStream

@export_group("Lidar com feitico de Salto")
## Feitico id do feitico a ser bloqueado ate o jogador cair no chao
@export var feitico_id_bloqueado_ate_cair_chao: String = "PuloImpulsionado"
## Quantidade de usos do feitico, ate o jogador cair no chao
@export var qtde_usos_ate_chao: int = 2
var qtde_usos_ate_chao_atual : int = 0

@onready var registro_feiticos: RegistroFeiticos = Registros.reg_feiticos

@onready var ray_cast_visao: RayCast3D = $RayCast3D
@onready var audio_stream_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

## Hud do jogador desse PC
var hud_jogador: HUDJogador
## Peer id do jogador que eh dono desse lancador de feiticos
var jogador_id : int

## Segundos restantes de cooldown para um Feitico_id
var _cooldowns: Dictionary[String, float] = {}

## Lista de feitico_id de feiticos bloqueados
var feiticos_bloqueados: Array[String]

var selecao_feitico_id: int = 0

func _ready() -> void:
	audio_stream_player.stream = audio_cast

# Capturar Inputs
# -----------------------------------------------------------------------------

func _input(_event: InputEvent) -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE: return
	
	if Input.is_action_just_pressed("acao"):
		# apertar
		_tentar_lancar_feitico()

func _process(delta: float) -> void:
	_process_cooldowns(delta)
	
	if Input.is_action_just_pressed("feitico_prox"):
		hud_jogador.add_idx(1)
		_mostrar_custo_mana(hud_jogador.get_feitico_id_from_idx())
	if Input.is_action_just_pressed("feitico_prev"):
		hud_jogador.add_idx(-1)
		_mostrar_custo_mana(hud_jogador.get_feitico_id_from_idx())

func _physics_process(_delta: float) -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE: return
	
	if Input.is_action_pressed("acao"):
		_tentar_canalizar_feitico()

func _process_cooldowns(delta: float) -> void:
	for feitico_id : String in _cooldowns:
		# atualiza o cooldown
		_cooldowns[feitico_id] = maxf(0.0, _cooldowns[feitico_id] - delta)
		# atualiza na hud o valor de lancavel ou nao
		hud_jogador.update_lancavel(feitico_id, _esta_lancavel(feitico_id))

# Lancar Feitico
# -----------------------------------------------------------------------------

func _tentar_lancar_feitico() -> void:
	var feitico_id : String = get_feitico_escolhido()
	if feitico_id == "": return
	
	var feitico_def := Registros.reg_feiticos.get_feitico(feitico_id)
	if feitico_def.lancamento == Feitico.Lancamento.DISPARO:
		processar_lancar_feitico(feitico_id)

func _tentar_canalizar_feitico() -> void:
	var feitico_id : String = get_feitico_escolhido()
	if feitico_id == "": return
	
	var feitico_def := Registros.reg_feiticos.get_feitico(feitico_id)
	if feitico_def.lancamento == Feitico.Lancamento.CANALIZAR:
		processar_lancar_feitico(feitico_id)

## Retorna o feitico que a hud tem como escolhido atualmente
func get_feitico_escolhido() -> String:
	return hud_jogador.get_feitico_id_from_idx()

## Retorna True somente se dado feitico_id esta apto a ser lancado
func _esta_lancavel(feitico_id: String) -> bool:
	# verifica se esta no cooldown, (nao esta no cooldown, se o cooldown for 0.0)
	var esta_cooldown: bool = _cooldowns.get(feitico_id, 0) > 0.01
	# esta bloqueado
	var bloqueado: bool = feiticos_bloqueados.has(feitico_id)
	# pode ser lancado
	#var lancavel: bool = (not esta_cooldown) and (not bloqueado)
	var lancavel: bool = not (esta_cooldown or bloqueado)
	return lancavel

## Processa cooldown, custo de mana, contexto para lancar o feitico 
func processar_lancar_feitico(feitico_id: String) -> void:
	# --- Faz as verificacoes antes de lancar ---
	
	# se nao estiver lancavel, nao continue
	if not _esta_lancavel(feitico_id): return
	
	# pega as definicoes do feitico
	var feitico_def : FeiticoDef = registro_feiticos.get_feitico(feitico_id)
	# verifica se tem mana o suficiente para criar o feitico
	if not sistema_mana.tem_mana_suficiente(feitico_def.custo): return
	
	# --- Tenta criar o Contexto do Feitico ---
	# cria o contexto do feitico
	var feitico_contexto : FeiticoContexto = _criar_feitico_contexto(feitico_def)
	# se nao foi possivel criar o contexto (ou lancar o feitico) pare
	if not feitico_contexto: return
	
	# --- Gasta os recursos para lancar ---
	# coloque o feitico no cooldown
	_cooldowns[feitico_id] = feitico_def.cooldown
	# gasta a amana
	sistema_mana.gastar_mana(feitico_def.custo)
	
	# --- Lanca o feitico ---
	_lancar_feitico(feitico_contexto)

func _criar_feitico_contexto(feitico_def : FeiticoDef) -> FeiticoContexto:
	var feitico_contexto := FeiticoContexto.criar(feitico_def, self)
	return feitico_contexto

## emite que esta lancando um feitico
func _lancar_feitico(feitico_contexto : FeiticoContexto) -> void:
	lancar_feitico.emit(feitico_contexto)
	# emite o audio
	audio_stream_player.play()
	# contar para o salto
	if feitico_contexto.feitico_id == feitico_id_bloqueado_ate_cair_chao:
		_usar_salto()


# Bloqueios de feitico
# -----------------------------------------------------------------------------

func bloquear_feitico(feitico_id: String, bloqueado: bool = true) -> void:
	# bloqueia
	if bloqueado:
		feiticos_bloqueados.append(feitico_id)
	# desbloqueia, se estiver bloqueado
	elif feiticos_bloqueados.has(feitico_id):
		feiticos_bloqueados.erase(feitico_id)

func jogador_caiu_chao() -> void:
	bloquear_feitico(feitico_id_bloqueado_ate_cair_chao, false)
	qtde_usos_ate_chao_atual = 0

# Diracao da Mira
# -----------------------------------------------------------------------------

## Retorna a direcao normalizada que o lancador de feiticos esta mirando
func get_direcao_mirando() -> Vector3:
	var direcao : Vector3 = -get_global_transform().basis.z
	return direcao.normalized()

## Retorna a posicao global do lancador de feiticos ao fazer um raycast.
## 		Retorna Vector3.INF se o raycast nao colidir
func get_posicao_global_mirando() -> Vector3:
	# TODO: corrigir isso, problema que fazer o await cria uma cadeia de await
	# 		criar func especifica para posicionar (feiticos que usam raycast)
	## so executa o raycast dentro do physics_frame
	#if not Engine.is_in_physics_frame():
		#await get_tree().physics_frame
	#
	ray_cast_visao.force_raycast_update()
	if ray_cast_visao.is_colliding():
		var posicao_global := ray_cast_visao.get_collision_point()
		return posicao_global
	# 
	return Vector3.INF

# Mostrar Mana
# -----------------------------------------------------------------------------

func _mostrar_custo_mana(feitico_id: String) -> void:
	var feitico_def : FeiticoDef = registro_feiticos.get_feitico(feitico_id)
	var custo_mana : float = feitico_def.custo
	if sistema_mana.tem_mana_suficiente(custo_mana):
		var custo_porcent : float = sistema_mana.calc_porcentegem_mana(custo_mana)
		hud_jogador.atualizar_custo_mana_previsto(custo_porcent)
	else:
		hud_jogador.atualizar_custo_mana_previsto(0.0)

# TODO: arranjar solucao melhor
# Lidar com salto
# -----------------------------------------------------------------------------

func _usar_salto() -> void:
	qtde_usos_ate_chao_atual += 1
	if qtde_usos_ate_chao_atual >= qtde_usos_ate_chao:
		bloquear_feitico(feitico_id_bloqueado_ate_cair_chao, true)
