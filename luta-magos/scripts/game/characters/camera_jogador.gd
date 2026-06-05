class_name CameraJogador
extends Node3D

# TODO: trocar essa referencia de corpo por outra coisa
@export var jogador_corpo : JogadorCorpo

@onready var camera: Camera3D = $Camera

@onready var pivot_olhando: Node3D = $Camera/PivotOlhando

@onready var remote_transform_mira: RemoteTransform3D = $Camera/RemoteTransformMira
@onready var remote_transform_cabeca: RemoteTransform3D = $Camera/PivotOlhando/RemoteTransformCabeca

const SENSITIVITY_BASE_MOUSE := 0.005
const SENSITIVITY_BASE_CONTROLLER := 5.0

var mouse_sensitivity 		:= SENSITIVITY_BASE_MOUSE
var controller_sensitivity 	:= SENSITIVITY_BASE_CONTROLLER

var has_controller : bool = false

func start() -> void:
	# TODO: verificar isso
	has_controller = Input.get_connected_joypads().size() > 0
	set_process(has_controller)
	
	camera.make_current()
	
	# TODO: garantir que isso esta habilitado isso na build final
	if not OS.is_debug_build():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_rotacionar_camera(event.relative, 1)

func _process(delta):
	# Get vector from the right analog stick
	var look_input = Input.get_vector("olhar_esquerda", "olhar_direita", "olhar_cima", "olhar_baixo")

	if look_input.length() > 0.1: # Small deadzone check
		_rotacionar_camera(look_input, delta)

func _rotacionar_camera(look_input: Vector2, delta: float) -> void:
	var sensitivity : float = controller_sensitivity if has_controller else mouse_sensitivity
	
	# Rotate horizontally (around Y axis)
	jogador_corpo.rotate_y(-look_input.x * sensitivity * delta)
	# Rotate vertically (around local X axis)
	camera.rotate_x(-look_input.y * sensitivity * delta)
	camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	# rodar a cabeca
	var cabeca_rot = remap(rotation.x, -PI/2, PI/2, -PI/4, PI/4)
	pivot_olhando.rotation.x = cabeca_rot


func set_sensibilidade(sensi: float) -> void:
	# Controle
	if has_controller:
		controller_sensitivity = SENSITIVITY_BASE_CONTROLLER * sensi
	# Mouse
	else:
		mouse_sensitivity = SENSITIVITY_BASE_MOUSE * sensi

func set_target_remote_transform_mira(node_path: String) -> void:
	_set_target_of_remote_transform(remote_transform_mira, node_path)

func set_target_remote_transform_cabeca(node_path: String) -> void:
	_set_target_of_remote_transform(remote_transform_cabeca, node_path)

func _set_target_of_remote_transform(
	remote_transform: RemoteTransform3D,
	node_path: String
) -> void:
	remote_transform.remote_path = node_path
	remote_transform.force_update_cache()
