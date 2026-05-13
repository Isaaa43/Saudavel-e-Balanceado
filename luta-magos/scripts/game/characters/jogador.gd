extends CharacterBody3D
class_name Jogador

@export var sistema_vida : SistemaVida
@export var sistema_mana : SistemaMana

@onready var camera_3d: Camera3D = $Cabeca/Camera3D
@onready var lancador_feiticos: LancadorFeiticos = $Cabeca/Camera3D/LancadorFeiticos

var dados_jogador : DadosJogador :
	set(_dados_jog):
		dados_jogador = _dados_jog
		call_deferred("_display_nome")

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

func _ready() -> void:
	# se nao for este computador controlando esse nodo, desligue esse nodo
	if not is_multiplayer_authority():
		_turn_off(self)
		_turn_off(camera_3d)
		_turn_off(lancador_feiticos)
		return
	
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

@onready var label_nome: Label3D = $LabelNome
func _display_nome() -> void:
	if not (dados_jogador and is_instance_valid(dados_jogador)): return
	if not (label_nome and is_instance_valid(label_nome)): return
	
	var nome : String = dados_jogador.nome
	if dados_jogador.nome and dados_jogador.nome != "" and (not dados_jogador.nome.is_empty()):
		label_nome.text = nome

# -----------------------------------------------------------------------------
# Sistema Vida
# -----------------------------------------------------------------------------
func receber_dano(dano: float) -> void:
	sistema_vida.receber_dano(dano)
	
func receber_vida(vida: float) -> void:
	sistema_vida.receber_vida(vida)
