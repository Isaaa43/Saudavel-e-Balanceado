class_name JogadorCorpo
extends CharacterBody3D

@onready var cabeca_pivot: Node3D = $Corpo/Cabeca/CabecaPivot
@onready var remote_transform_cabeca: RemoteTransform3D = $Corpo/Cabeca/RemoteTransformCabeca

@onready var audio_player_dano: AudioStreamPlayer3D = $AudioPlayerDano
@onready var label_dano: Label3D = $LabelDano


func conectar_camera(camera_jogador: CameraJogador) -> void:
	var camera_path := camera_jogador.get_path()
	remote_transform_cabeca.remote_path = camera_path
	remote_transform_cabeca.force_update_cache()
	
	camera_jogador.set_target_remote_transform_cabeca(cabeca_pivot.get_path())

func mostrar_levar_dano(dano: float) -> void:
	audio_player_dano.play()
	# TODO: remover
	# mostra o dano em cima do jog
	label_dano.text = "Dano:\n%d" % dano
	label_dano.show()
	get_tree().create_timer(1.2).timeout.connect( func(): label_dano.hide() )

# TODO: arrumar
@onready var label_nome: Label3D = $LabelNome
func _display_nome(dados_jogador) -> void:
	if not (dados_jogador and is_instance_valid(dados_jogador)): return
	if not (label_nome and is_instance_valid(label_nome)): return
	
	var nome : String = dados_jogador.nome
	if dados_jogador.nome and dados_jogador.nome != "" and (not dados_jogador.nome.is_empty()):
		label_nome.text = nome
