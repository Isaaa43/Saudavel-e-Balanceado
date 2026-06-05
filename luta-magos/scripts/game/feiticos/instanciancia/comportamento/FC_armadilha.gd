class_name FeiticoComportamentoArmadilha
extends FeiticoComportamento

## Tempo em segundos para reativar o feitico.
## 		Valores menores que 0.1 nao sao ativados
var reativacao_seg: float

var comportamento_ativacao_def : FeiticoComportamentoDef : 
	set(_comportamento_ativacao_def):
		comportamento_ativacao_def = _comportamento_ativacao_def
		print(" setado: ", comportamento_ativacao_def)
var comportamento_ativacao : FeiticoComportamento

var efeitos_ativacao : Array[FeiticoEfeito] = []

var pronto_ativar: bool = true

func iniciar_comportamento() -> void:
	# TODO: achar solucao melhor q esse hack
	if comportamento_ativacao_def:
		area_ativacao.body_entered.disconnect(_entrou_area_aplicar_efeitos)
		area_ativacao.body_entered.connect(_verificar_ativar_armadilha)

func _verificar_ativar_armadilha(_corpo_entrou: Node3D) -> void:
	var entidade: Entidade = Entidade.get_entidade_from_corpo(_corpo_entrou)
	var receptor: ReceptorEfeitos = entidade.receptor_efeitos
	
	if _deve_aplicar_efeito(entidade):
		_ativar_armadilha()

func _ativar_armadilha() -> void:
	# reativacao depois de passar reativacao_seg
	# se o jogador ficar em cima da armadilha ela n reativa
	if not pronto_ativar: return
	pronto_ativar = false
	get_tree().create_timer(reativacao_seg).timeout.connect(_reativacao_pronta)
	
	# cria o comportamento de ativacao
	comportamento_ativacao = comportamento_ativacao_def.criar(contexto)
	comportamento_ativacao.set_feitico_tipo(feitico_tipo)
	# ajustar
	comportamento_ativacao.contexto = contexto
	comportamento_ativacao.name = "ComportamentoAtivacao"
		# importante destruir esse, ja que vai criar outro na prox ativacao
	comportamento_ativacao.acabou.connect(comportamento_ativacao.destruir)
	add_child(comportamento_ativacao, true)
	comportamento_ativacao.iniciar()

func _reativacao_pronta() -> void:
	pronto_ativar = true
	lista_sei_entraram_area_efeito.clear()

func physics_process(_delta: float) -> void:
	pass

func aplicar_efeitos(jogador: Jogador) -> void:
	_ativar_armadilha()
	
	for efeito : FeiticoEfeito in efeitos_ativacao:
		efeito.aplicar(jogador)
