extends Camera3D

@export var jogador : Jogador
@export var cabeca : Node3D

var mouse_sensitivity := 0.005
var controller_sensitivity := 5.0

var has_controller : bool = false

func start() -> void:
	# TODO: verificar isso
	has_controller = Input.get_connected_joypads().size() > 0
	set_process(has_controller)
	
	make_current()
	
	# TODO: garantir que isso esta habilitado isso na build final
	if not OS.is_debug_build():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	#if not is_multiplayer_authority(): return
	
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		jogador.rotate_y(-event.relative.x * mouse_sensitivity)
		rotate_x(-event.relative.y * mouse_sensitivity)
		rotation.x = clamp(rotation.x, -PI/2, PI/2)
		# rodar a cabeca
		var cabeca_rot = remap(rotation.x, -PI/2, PI/2, -PI/4, PI/4)
		cabeca.rotation.x = cabeca_rot


func _process(delta):
	# Get vector from the right analog stick
	var look_input = Input.get_vector("olhar_esquerda", "olhar_direita", "olhar_cima", "olhar_baixo")

	if look_input.length() > 0.1: # Small deadzone check
		# Rotate horizontally (around Y axis)
		jogador.rotate_y(-look_input.x * controller_sensitivity * delta)
		# Rotate vertically (around local X axis)
		rotate_x(-look_input.y * controller_sensitivity * delta)
		rotation.x = clamp(rotation.x, -PI/2, PI/2)
		# rodar a cabeca
		var cabeca_rot = remap(rotation.x, -PI/2, PI/2, -PI/4, PI/4)
		cabeca.rotation.x = cabeca_rot

func _input(event):	
	# esc para sair do capture
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# click
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
