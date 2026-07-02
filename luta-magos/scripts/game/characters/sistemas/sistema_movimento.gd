class_name SistemaMovimento
extends Node

signal congelado(duracao_seg: bool)
signal caiu_chao

@export var jogador: JogadorCorpo

@export var velocidade = 5.0
const JUMP_VELOCITY = 4.5

## Multiplicador de velocidade do jogador, usado por efeitos
var velocidade_mult := 1.0

var ignorar_input_movimento: bool = false


var esta_chao: bool :
	set(_esta_chao):
		# nao estava no chao, mas agora esta
		if (not esta_chao) and _esta_chao: 
			caiu_chao.emit()
		esta_chao = _esta_chao

func congelar(duracao_seg: float) -> void:
	# efeitos de congelamento
	ignorar_input_movimento = true
	congelado.emit(duracao_seg)
	# espera terminar a duracao o efeito
	await get_tree().create_timer(duracao_seg).timeout
	# retira os efeitos do congelamento
	ignorar_input_movimento = false

## Adiciona [code]mult[/code] ao [b]multiplador de velocidade[/b] por [code]duracao segundos[/code] 
## [br] Depois remove o valor [code]mult[/code] do [b]multiplador de velocidade[/b]
## [br] [code]mult[/code] negativos dão [b]slow[/b] ao jogador, enquanto [b]positivos[/b] dão boost
## [br] Assim deve ser possivel adicionar multiplos efeitos de mudanca ao mesmo tempo
func mudar_velocidade(mult: float, duracao_seg: float) -> void:
	# adiciona ao multiplicador de velocidade
	velocidade_mult += mult
	# retira essa adicao apos a duracao acabar
	get_tree().create_timer(duracao_seg).timeout.connect(
		func(): velocidade_mult -= mult
	)

func _process(delta: float) -> void:
	# Add the gravity.
	if not jogador.is_on_floor():
		jogador.velocity += jogador.get_gravity() * delta
	#
	_process_movimentacao(delta)

func _physics_process(_delta: float) -> void:
	esta_chao = jogador.is_on_floor()
	jogador.sistema_animacao.set_esta_chao(esta_chao)

# Movimentacao
# -----------------------------------------------------------------------------
func _process_movimentacao(_delta: float) -> void:
	if ignorar_input_movimento: return
	
	# Handle jump.
	if Input.is_action_just_pressed("pular") and jogador.is_on_floor():
		jogador.velocity.y = JUMP_VELOCITY
	
	# limitar o minimo do multiplicador de velocidade em 0
	var _velocidade_mult: float = max(0.0, velocidade_mult)
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("esquerda", "direita", "frente", "tras")
	var direction := (jogador.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		jogador.velocity.x = direction.x * velocidade * _velocidade_mult
		jogador.velocity.z = direction.z * velocidade * _velocidade_mult
		jogador.sistema_animacao.set_esta_movendo(true)
	else:
		jogador.velocity.x = move_toward(jogador.velocity.x, 0, velocidade * _velocidade_mult)
		jogador.velocity.z = move_toward(jogador.velocity.z, 0, velocidade * _velocidade_mult)
		jogador.sistema_animacao.set_esta_movendo(false)
	
	# Move and Slide aplica o delta automaticamente
	jogador.move_and_slide()
