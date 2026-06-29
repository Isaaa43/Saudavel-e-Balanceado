class_name FeiticoComportamentoBomba
extends FeiticoComportamento

var velocidade: float

var tamanho_raio: float

var efeitos_impacto : Array[FeiticoEfeito] = []

var direcao := Vector3.ZERO

var explosao_comportamento_def : FeiticoComportamentoDef

var explosao_comportamento : FeiticoComportamento

func iniciar_comportamento() -> void:
	direcao = contexto.direcao
	if corpo.corpo_movimento is RigidBody3D:
		corpo.corpo_movimento.apply_impulse(direcao * velocidade)
	
	# Acabar o tempo explode a bomba
	var feitico := get_parent() as Feitico
	acabou.disconnect(feitico.destruir)
	acabou.connect(_ativar_explosao)
	
	# TODO: achar solucao melhor q esse hack
	if explosao_comportamento_def:
		area_ativacao.body_entered.disconnect(_entrou_area_aplicar_efeitos)
		area_ativacao.body_entered.connect(_verificar_ativar_explosao)
	# pega o componente da entidade
	var feitico_scene := visual.get_child(0)
	for c in feitico_scene.get_children():
		if c is EntidadeFeitico:
			c.criador_id = contexto.criador_id

func _verificar_ativar_explosao(_corpo_entrou: Node3D) -> void:
	var entidade: Entidade = Entidade.get_entidade_from_corpo(_corpo_entrou)
	var receptor: ReceptorEfeitos = entidade.receptor_efeitos
	
	if _deve_aplicar_efeito(entidade):
		_ativar_explosao()

func _ativar_explosao() -> void:
	# cria o comportamento de ativacao
	explosao_comportamento = explosao_comportamento_def.criar(contexto)
	explosao_comportamento.set_feitico_tipo(feitico_tipo)
	# ajustar
	explosao_comportamento.contexto = contexto
	explosao_comportamento.name = "ComportamentoExplosao"
		# importante destruir esse, ja que vai criar outro na prox ativacao
	explosao_comportamento.acabou.connect(explosao_comportamento.destruir)
	get_parent().add_child(explosao_comportamento, true)
	# altera o local da explosao para a posicao da bomba
	var global_pos_explosao := corpo.corpo_movimento.global_position
	explosao_comportamento.contexto.posicao_global_inicial = global_pos_explosao
	# inicia
	explosao_comportamento.iniciar()
	# destroi a bomba
	destruir()

func physics_process(delta: float) -> void:
	pass
