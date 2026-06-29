class_name SistemaMovimento
extends Node

signal congelado(duracao_seg: bool)

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var jogador: JogadorCorpo

func congelar(duracao_seg: float) -> void:
	# efeitos de congelamento
	set_process(false) # para o processamento desse nodo
	congelado.emit(duracao_seg)
	# espera terminar a duracao o efeito
	await get_tree().create_timer(duracao_seg).timeout
	# retira os efeitos do congelamento
	set_process(true) # volta o processamento desse nodo

func _process(delta: float) -> void:
	# Add the gravity.
	if not jogador.is_on_floor():
		jogador.velocity += jogador.get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("pular") and jogador.is_on_floor():
		jogador.velocity.y = JUMP_VELOCITY
		jogador.sistema_animacao.acao(SistemaAnimacao.Animacao.PULAR)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("esquerda", "direita", "frente", "tras")
	var direction := (jogador.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		jogador.velocity.x = direction.x * SPEED
		jogador.velocity.z = direction.z * SPEED
		jogador.sistema_animacao.acao(SistemaAnimacao.Animacao.ANDAR)
	else:
		jogador.velocity.x = move_toward(jogador.velocity.x, 0, SPEED)
		jogador.velocity.z = move_toward(jogador.velocity.z, 0, SPEED)
		jogador.sistema_animacao.acao(SistemaAnimacao.Animacao.IDLE)

	jogador.move_and_slide()
