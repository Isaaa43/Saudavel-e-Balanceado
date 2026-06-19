@abstract
class_name FeiticoComportamento
extends Node

signal acabou

enum Afetados {
	TODOS, 		## Todos
	CRIADOR,	## Somente o criador do feitico
	ALVO,		## Somente o alvo selecionado
	ALIADOS,	## Todos os aliados
	INIMIGOS,	## Todos os inimigos
	TODOS_EXCETO_CRIADOR, 	## Todos, exceto o criador do feitico
	TODOS_EXCETO_ALVO, 		## Todos, exceto o alvo do feitico
}

# Duracao
# -----------------------------------------------------------------------------
var duracao_seg_restante: float
var tem_duracao : bool = true

# Efeitos
# -----------------------------------------------------------------------------
var afetados : Afetados

## Camadas de fisica 3d que sao afetadas
var mask_afetados : int :
	set(_mask_afetados):
		mask_afetados = _mask_afetados
		area_ativacao.mask_afetados = _mask_afetados
 
var efeitos : Array[FeiticoEfeito] = []

## Lista dos Nodos3D que sabemos que ja entraram e foram processados na area de efeito
var lista_sei_entraram_area_efeito : Array[Node3D] = []

# Corpo Feitico
# -----------------------------------------------------------------------------
var corpo: FeiticoCorpo

# Area Ativacao
# -----------------------------------------------------------------------------
var area_ativacao: FeiticoAreaAtivacao

# Visual
# -----------------------------------------------------------------------------
var visual: FeiticoVisual
var audio_stream : AudioStream

# Dados Feitico
# -----------------------------------------------------------------------------
var contexto: FeiticoContexto

# -----------------------------------------------------------------------------
# Init e Ready do node
# -----------------------------------------------------------------------------

func _init(duracao_seg: float) -> void:
	duracao_seg_restante = duracao_seg
	
	if duracao_seg < 0.1:
		duracao_seg_restante = 999
		tem_duracao = false

func _ready() -> void:
	# desliga a fisca ate iniciar() ser chamado
	set_physics_process(false)
	
	# criar sub sistemas
	_ready_sub_sistemas()

func _ready_sub_sistemas() -> void:
	# Visual 
	visual.name = "Visual"
	add_child(visual, true)
	# AreaAtivacao
	area_ativacao.name = "AreaAtivacao"
	add_child(area_ativacao, true)
	area_ativacao.body_entered.connect(_entrou_area_aplicar_efeitos)
	# Corpo
	corpo.name = "Corpo"
	add_child(corpo, true)
	corpo.set_visual_transform(visual.visual_3d)
	corpo.set_area_transform(area_ativacao)

# -----------------------------------------------------------------------------
# Efeitos
# -----------------------------------------------------------------------------

func criar_efeitos(lista_efeito_def: Array[FeiticoEfeitoDef]) -> void:
	for efeito_def : FeiticoEfeitoDef in lista_efeito_def:
		efeitos.append(efeito_def.criar())

func _entrou_area_aplicar_efeitos(_corpo_entrou: Node3D) -> void:
	if lista_sei_entraram_area_efeito.has(_corpo_entrou): return
	lista_sei_entraram_area_efeito.append(_corpo_entrou)
	
	var entidade: Entidade = Entidade.get_entidade_from_corpo(_corpo_entrou)
	var receptor: ReceptorEfeitos = entidade.receptor_efeitos
	# ReceptorEfeitos.encontrar_receptor_efeitos(node)
	if receptor != null and entidade != null:
		_aplicar_efeitos_receptor(receptor, entidade)

func _aplicar_efeitos_receptor(receptor: ReceptorEfeitos, entidade: Entidade) -> void:
	if _deve_aplicar_efeito(entidade) or entidade.is_especial:
		receptor.receber_lista_efeitos(efeitos)

func _deve_aplicar_efeito(entidade: Entidade) -> bool:
	var entidade_id : int
	
	if entidade is Jogador:
		var jog: Jogador = entidade
		entidade_id = jog.dados_jogador.peer_id
	elif entidade is EntidadeFeitico:
		entidade_id = entidade.criador_id
	
	# ------------------
	
	match (afetados):
		Afetados.TODOS:
			return true
		Afetados.CRIADOR:
			# somente criador do feitico
			if entidade_id == contexto.criador_id:
				return true
		Afetados.ALVO:
			# somente alvo do feitico
			if entidade_id == contexto.alvo_id:
				return true
		Afetados.ALIADOS:
			# TODO:
			# somente criador e (aliados do criador)
			if entidade_id != contexto.criador_id:
				return true
		Afetados.INIMIGOS:
			# TODO:
			# somente inimigos
			if entidade_id != contexto.criador_id:
				return true
		Afetados.TODOS_EXCETO_CRIADOR:
			# todos, exceto somente o criador do feitico
			if entidade_id != contexto.criador_id:
				return true
		Afetados.TODOS_EXCETO_ALVO:
			# todos, exceto somente o alvo do feitico
			if entidade_id != contexto.alvo_id:
				return true
	# se nao cair em nenhum, false
	return false

# -----------------------------------------------------------------------------
# Iniciar
# -----------------------------------------------------------------------------

func iniciar() -> void:
	# posiciona o corpo do feitico no local, e inicia o process da fisica
	corpo.global_position = contexto.posicao_global_inicial
	set_physics_process(true)
	# TODO melhorar: se tiver particulas, comece a emitr
	if visual.particulas:
		visual.particulas.emitting = true
	# audio
	# TODO: melhorar essa parte
	if audio_stream:
		var audio_player := AudioStreamPlayer3D.new()
		audio_player.stream = audio_stream
		corpo.add_child(audio_player)
		audio_player.play()
	# inicia o comportamento especifico das classes derivadas
	iniciar_comportamento()

@abstract
func iniciar_comportamento() -> void

# -----------------------------------------------------------------------------
# Fim
# -----------------------------------------------------------------------------

func acabar() -> void:
	acabou.emit()

func destruir() -> void:
	queue_free()

# -----------------------------------------------------------------------------
# Processar
# -----------------------------------------------------------------------------

@abstract
func physics_process(delta: float) -> void

func _physics_process(delta: float) -> void:
	duracao_seg_restante -= delta
	if (duracao_seg_restante <= 0.0 and tem_duracao):
		acabar()
	
	physics_process(delta)

# -----------------------------------------------------------------------------
# Area Ativacao
# -----------------------------------------------------------------------------
# TODO: colocar no init ?
var feitico_tipo: Feitico.Tipo
func set_feitico_tipo(tipo: Feitico.Tipo) -> void:
	area_ativacao.set_feitico_tipo(tipo)
	feitico_tipo = tipo
