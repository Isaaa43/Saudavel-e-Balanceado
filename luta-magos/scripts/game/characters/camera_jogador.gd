class_name CameraJogador
extends Node3D

# TODO: trocar essa referencia de corpo por outra coisa
@export var corpo_rotacao : Node3D

@onready var camera: Camera3D = $Camera

@onready var remote_transform_mira: RemoteTransform3D = $Camera/RemoteTransformMira

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

# TODO: ver se precisa linkar isso com o delta time (como o process) ou algo assim
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
	var rot_y : float = -look_input.x * sensitivity * delta
	rotate_y(rot_y)
	corpo_rotacao.rotate_y(rot_y)
	# Rotate vertically (around local X axis)
	camera.rotate_x(-look_input.y * sensitivity * delta)
	camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)


func set_sensibilidade(sensi: float) -> void:
	# Controle
	if has_controller:
		controller_sensitivity = SENSITIVITY_BASE_CONTROLLER * sensi
	# Mouse
	else:
		mouse_sensitivity = SENSITIVITY_BASE_MOUSE * sensi

func set_target_remote_transform_mira(node_path: String) -> void:
	remote_transform_mira.remote_path = node_path
	remote_transform_mira.force_update_cache()
