extends Feitico

@export var speed: float = 2.0
@export var lifetime: float = 6.0

var _elapsed: float = 0.0

func _ready() -> void:
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

func _verificar_corpo(node: Node3D) -> void:
	# se passou por um jogador
	if node is Jogador:
		var jog : Jogador = node
		# ignora o jogador que criou o feitico
		if jog == criador: return
		# outros jogadores
		print("Spotou jog: ", jog.dados_jogador.nome)
		# acabe aqui
		return
		
	# se passou por um feitico
	if node is Feitico:
		var feitico : Feitico = node
		# nao revela as propria traps
		if feitico.criador == criador: return
		# outras traps
		print("Spotou jog: ", feitico.nome)
	
	# nao era jogador
	print("Spotou algo: ", node)

func _on_body_entered(body: Node3D) -> void:
	_verificar_corpo(body)

func _on_area_3d_area_entered(area: Area3D) -> void:
	_verificar_corpo(area)
