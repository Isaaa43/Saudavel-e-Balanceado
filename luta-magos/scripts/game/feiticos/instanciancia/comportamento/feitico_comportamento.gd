@abstract
class_name FeiticoComportamento
extends Node

signal acabou

enum Afetados {
	TODOS, 		## Todos
	SOLO,		## Somente o criador do feitico
	ALVO,		## Somente o alvo selecionado
	ALIADOS,	## Todos os alidos
	INIMIGOS,	## Todos os inimigos
}

# Duracao
# -----------------------------------------------------------------------------
var duracao_seg_restante: float
var tem_duracao : bool = true

# Efeitos
# -----------------------------------------------------------------------------
var afetados : Afetados
var mask_afetados : Variant
 
var efeitos : Array[FeiticoEfeito] = []

# Corpo Feitico
# -----------------------------------------------------------------------------
var corpo: FeiticoCorpo
var direcao := Vector3.ZERO

# Area Ativacao
# -----------------------------------------------------------------------------
var area_ativacao: FeiticoAreaAtivacao

# Visual
# -----------------------------------------------------------------------------
var visual: FeiticoVisual


func _init(duracao_seg: float) -> void:
	duracao_seg_restante = duracao_seg
	
	if duracao_seg < 0.1:
		duracao_seg_restante = 999
		tem_duracao = false

func _ready() -> void:
	set_physics_process(false)
	# TODO AAAAAA
	
	# Visual 
	visual.name = "Visual"
	add_child(visual, true)
	# AreaAtivacao
	area_ativacao.name = "AreaAtivacao"
	add_child(area_ativacao, true)
	area_ativacao.body_entered.connect(_aplicar_efeitos)
	# Corpo
	corpo.name = "Corpo"
	add_child(corpo, true)
	corpo.set_visual_transform(visual.visual_3d)
	corpo.set_area_transform(area_ativacao)

func _aplicar_efeitos(body: Node3D) -> void:
	if body is Jogador:
		var jog : Jogador = body
		
		for efeito: FeiticoEfeito in efeitos:
			jog.receber_feitico_efeito(efeito)

@abstract
func physics_process(delta: float) -> void

func _physics_process(delta: float) -> void:
	duracao_seg_restante -= delta
	if (duracao_seg_restante <= 0.0 and tem_duracao):
		acabar()
	
	physics_process(delta)

func iniciar(pos_global_inicial: Vector3) -> void:
	corpo.global_position = pos_global_inicial
	set_physics_process(true)
	if visual.particulas:
		visual.particulas.emitting = true

func acabar() -> void:
	acabou.emit()

func set_feitico_tipo(tipo: Feitico.Tipo) -> void:
	area_ativacao.set_feitico_tipo(tipo)
