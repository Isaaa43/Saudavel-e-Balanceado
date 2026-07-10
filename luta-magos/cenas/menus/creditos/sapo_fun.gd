extends Node2D

@onready var spawn_point: Node2D = $SpawnPoint

const SAPONA_RB = preload("uid://cmfnnsn2uxyhr")

@export var qtd_max : int = 4

var qtd_atual : int = 0

func _ready() -> void:
	show()
	await get_tree().create_timer(10.0).timeout
	_spawn()

func _spawn() -> void:
	# se chegou no limite pare
	if qtd_atual >= qtd_max: return
	# aumente em 1
	qtd_atual += 1
	# cria a sapona
	var sapona = SAPONA_RB.instantiate() as RigidBody2D
	add_child(sapona)
	# posiciona
	var pos : Vector2 = spawn_point.global_position
	pos += Vector2.UP.rotated(randf_range(-PI, PI)) * randf_range(50, 150)
	sapona.global_position = pos
	# cor
	_mudar_cor(sapona)
	# cria a prox
	get_tree().create_timer(randf_range(5, 15)).timeout.connect(_spawn)

func _mudar_cor(sapona: RigidBody2D) -> void:
	# nao muda a cor do primeiro
	if qtd_atual < 2: return
	
	sapona.modulate.s = randf_range(0, .25) *3
	sapona.modulate.h = randf_range(0, 1)
	sapona.modulate.v = randf_range(.7, 1)
