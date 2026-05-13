extends Feitico

@export var damage: float = 12.0

@onready var espinhos: Node3D = $Espinhos

func _ready() -> void:
	espinhos.hide()


## Cria a magia, antes de lancar
func criar() -> void:
	look_at(direcao, Vector3.UP)
	global_position = posicao_global_inicial

## Lanca a magia
func lancar() -> void:
	criar() 
	pass

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
	if not (body is Jogador): return
	var jog : Jogador = body
	if jog == criador: return
	
	espinhos.show()
	jog.receber_dano(damage)


func _on_body_exited(body: Node3D) -> void:
	if not (body is Jogador): return
	espinhos.hide()
