extends Feitico

@export var speed: float = 2.0
@export var damage: float = 25.0
@export var lifetime: float = 4.0

var _elapsed: float = 0.0

func _ready() -> void:
	
	#feitico_id = ""
	#nome = ""
	#feitico_tipo = Tipo.INSTANTANEO
#
	#criador = null
	#alvo = null
#
	#posicao_inicial = Vector3.ZERO
	#direcao = Vector3.ZERO
	
	#var fe := FeiticoEfeito.new()
	#efeitos.append(fe)
	
	pass


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

func _physics_process(delta: float) -> void:
	_elapsed += delta
	global_position += direcao * speed * delta
	if _elapsed >= lifetime:
		queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body == criador: return
	
	if body is Jogador:
		body.receber_dano(damage)
	
	print(body, " levou %d de " % damage, criador)
	
	#if body.has_method("take_damage"): pass
	#queue_free()
