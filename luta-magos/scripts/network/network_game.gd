extends Node

const JOGADOR = preload("uid://cqojyxy8t78mg")
@onready var jogadores: Node = $Jogadores

func _ready() -> void:
	NetworkMatch.spawnar_jogador.connect(spawnar_jogador)

func spawnar_jogador(id : int) -> void:
	var jogador := JOGADOR.instantiate()
	jogador.name = str(id)
	jogadores.add_child(jogador, true)
