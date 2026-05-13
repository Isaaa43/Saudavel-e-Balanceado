extends Feitico

@export var cura: float = 10

@onready var particulas : GPUParticles3D = $GPUParticles3D

## Cria a magia, antes de lancar
func criar() -> void:
	particulas.emitting = true
	global_position = posicao_global_inicial
	criador.sistema_vida.receber_vida(cura)

## Lanca a magia
func lancar() -> void:
	criar()
	# deletar
	await get_tree().create_timer(5).timeout
	queue_free()

## Ao colidir com objetos
func colidir() -> void:
	pass

## Ao acertar um objeto
func acertar() -> void:
	pass

## Aplicar os efeitos do feitico no alvo
func aplicar_efeito() -> void:
	pass
