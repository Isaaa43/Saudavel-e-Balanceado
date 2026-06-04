extends CharacterBody3D
class_name Jogador

@export var receptor_efeitos: ReceptorEfeitos
@export var sistema_vida : SistemaVida
@export var sistema_mana : SistemaMana

@onready var sistema_movimento: SistemaMovimento = $SistemaMovimento

@onready var camera_jogador: CameraJogador = $Cabeca/CameraJogador
@onready var cabeca_pivot: Node3D = $Cabeca/CabecaPivot

@onready var audio_player_dano: AudioStreamPlayer3D = $AudioPlayerDano
@onready var label_dano: Label3D = $LabelDano

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
		sistema_movimento.queue_free()
		return
	
	_ready_camera()
	# conectar os sinais
	sistema_vida.morreu.connect(morrer)
	sistema_vida.levou_dano.connect(_mostrar_levar_dano)

func _ready_camera() -> void:
	camera_jogador.start()
	# prende o lancador de feiticos na visao da camera
	camera_jogador.set_target_remote_transform_cabeca(cabeca_pivot.get_path())
	

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
func _mostrar_levar_dano(dano: float) -> void:
	audio_player_dano.play()
	# mostra o dano em cima do jog
	label_dano.text = "Dano:\n%d" % dano
	label_dano.show()
	get_tree().create_timer(1.2).timeout.connect( func(): label_dano.hide() )

func morrer() -> void:
	await get_tree().create_timer(0.5).timeout
	Network.client.pedir_terminar_partida()
