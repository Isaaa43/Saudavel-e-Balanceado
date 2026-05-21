class_name LocalAdm
extends Node

@export var hud : HUDJogador

@export var lancador_feiticos : LancadorFeiticos
@onready var remote_transform_3d: RemoteTransform3D = $RemoteTransform3D

var jogador : Jogador

func _ready() -> void:
	hud.show()
	lancador_feiticos.hud_jogador = hud

func ajustar_hud_jogador(_jogador: Jogador) -> void:
	jogador = _jogador
	_ajustar_hud()
	_ajustar_lancador_feiticos()


func _ajustar_hud() -> void:
	# conectar hud as mudanca de atributos do jogador
	jogador.sistema_vida.mudanca_vida.connect(hud.mostrar_vida)
	jogador.sistema_mana.mudanca_mana.connect(hud.mostrar_mana)
	
func _ajustar_lancador_feiticos() -> void:
	# conectar lancador de feiticos com o sistema de mana
	lancador_feiticos.sistema_mana = jogador.sistema_mana
	# prende o lancador de feiticos na visao da camera
	var pivot_path : String = jogador.camera_mira_pivot.get_path()
	remote_transform_3d.remote_path = pivot_path
