extends CharacterBody3D
class_name Jogador



@export var mesh_sapo : MeshInstance3D
@export var sapo_anim : AnimationPlayer

@onready var hud: HUDJogador = $Cabeca/Camera3D/HUDjogador

@onready var camera_3d: Camera3D = $Cabeca/Camera3D
@onready var lancador_feiticos: LancadorFeiticos = $Cabeca/Camera3D/LancadorFeiticos

var dados_jogador : DadosJogador

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _turn_off(node : Node) -> void:
	node.set_process(false)
	node.set_physics_process(false)
	node.set_process_input(false)
	node.set_process_unhandled_input(false)
	#node.process_mode = Node.PROCESS_MODE_DISABLED

func _enter_tree() -> void:
	set_multiplayer_authority(str(name).to_int())
	NetworkClient.jogadores[str(name).to_int()] = self
	
	print("Jogador %s  is_auth? " % name, is_multiplayer_authority())
	
	print("--------------")
	print("jogador %s (no id:%d)" % [name, multiplayer.get_unique_id()])

func _ready() -> void:
	# se nao for este computador controlando esse nodo, desligue esse nodo
	if not is_multiplayer_authority():
		hud = null
		_turn_off(self)
		_turn_off(camera_3d)
		_turn_off(lancador_feiticos)
		return
	
	mesh_sapo.set_layer_mask_value(2, true)
	mesh_sapo.set_layer_mask_value(1, false)
	camera_3d.start()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("pular") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("esquerda", "direita", "frente", "tras")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func play_lancar() -> void:
	sapo_anim.play("Take 001")
	await get_tree().create_timer(0.8).timeout
	sapo_anim.play("Idle")

var vida: int = 200
# TODO: somente teste, remover
@onready var label_dano: Label3D = $LabelDano
func levar_dano(dano: int) -> void:
	print('Levar dano %d' % dano)
	
	vida = vida - dano
	vida = max(0, vida)
	
	if hud:
		hud.set_vida(vida)
	
	# acabar partida
	if is_zero_approx(vida):
		await get_tree().create_timer(0.7).timeout
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		NetworkServer.terminar_partida()
	
	label_dano.text = "Dano:\n%d" % dano
	label_dano.show()
	get_tree().create_timer(1.2).timeout.connect( func(): label_dano.hide() )
