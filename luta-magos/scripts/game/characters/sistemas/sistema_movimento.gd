class_name SistemaMovimento
extends Node

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var jogador: JogadorCorpo

func congelar(duracao_seg: float) -> void:
	set_process(false)
	await get_tree().create_timer(duracao_seg).timeout
	set_process(true)

func _process(delta: float) -> void:
	# Add the gravity.
	if not jogador.is_on_floor():
		jogador.velocity += jogador.get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("pular") and jogador.is_on_floor():
		jogador.velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("esquerda", "direita", "frente", "tras")
	var direction := (jogador.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		jogador.velocity.x = direction.x * SPEED
		jogador.velocity.z = direction.z * SPEED
	else:
		jogador.velocity.x = move_toward(jogador.velocity.x, 0, SPEED)
		jogador.velocity.z = move_toward(jogador.velocity.z, 0, SPEED)

	jogador.move_and_slide()
