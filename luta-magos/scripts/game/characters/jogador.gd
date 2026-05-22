extends CharacterBody3D
class_name Jogador

@export var receptor_efeitos: ReceptorEfeitos
@export var sistema_vida : SistemaVida
@export var sistema_mana : SistemaMana

@onready var camera_jogador: CameraJogador = $Cabeca/CameraJogador

var dados_jogador : DadosJogador :
	set(_dados_jog):
		dados_jogador = _dados_jog
		call_deferred("_display_nome")

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
		camera_jogador.queue_free()
		return
	
	camera_jogador.start()
	# conectar os sinais
	sistema_vida.morreu.connect(morrer)

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
func morrer() -> void:
	await get_tree().create_timer(0.5).timeout
	Network.client.pedir_terminar_partida()
