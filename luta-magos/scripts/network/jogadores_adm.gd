extends Node

const JOGADOR = preload("uid://cqojyxy8t78mg")
@onready var jogadores: Node = $Jogadores

func _ready() -> void:
	NetworkClient.spawnar_jogador.connect(spawnar_jogador)
	pass

func spawnar_jogador(dados_jog : DadosJogador) -> void:
	var peer_id : int = dados_jog.peer_id
	print("spawnar_jogador dados: ", dados_jog, " id: ", peer_id)

	var jogador : Jogador = JOGADOR.instantiate()
	jogador.name = str(peer_id)
	jogador.dados_jogador = dados_jog
	
	jogadores.add_child(jogador, true)
	
	jogador.global_position = Vector3.ONE * randi_range(2, 5)
	jogador.velocity = Vector3.ZERO
