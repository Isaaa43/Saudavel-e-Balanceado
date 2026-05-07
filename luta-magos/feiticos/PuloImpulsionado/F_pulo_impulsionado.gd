extends Feitico

@onready var particulas : GPUParticles3D = $GPUParticles3D
@export var area_3d: Area3D

@export var forca_impulso : float = 10.0

var aplicado_por_body : Array[RigidBody3D] = []

## Cria a magia, antes de lancar
func criar() -> void:
	particulas.emitting = true
	global_position = posicao_global_inicial

## Lanca a magia
func lancar() -> void:
	criar() 
	# para de pular os objetos dentro
	await get_tree().create_timer(0.5).timeout
	area_3d.monitoring = false
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

func _on_body_entered(body: Node3D) -> void:
	if aplicado_por_body.has(body): return
	aplicado_por_body.append(body)
	
	if not (body is Jogador): return
	var jog : Jogador = body
	#if int(jog.name) == criador: return
	jog.velocity += Vector3.UP * forca_impulso

func _on_body_exited(body: Node3D) -> void:
	if not (body is Jogador): return
	
