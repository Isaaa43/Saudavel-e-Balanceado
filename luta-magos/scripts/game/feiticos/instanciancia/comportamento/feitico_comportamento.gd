@abstract
class_name FeiticoComportamento
extends Node

signal acabou

var tipo: Feitico.Tipo

var duracao_seg_restante: float
var tem_duracao : bool = true

var corpo: FeiticoCorpo
var direcao := Vector3.ZERO

func _init(duracao_seg: float) -> void:
	duracao_seg_restante = duracao_seg
	
	if duracao_seg < 0.1:
		duracao_seg_restante = 999
		tem_duracao = false

func _ready() -> void:
	set_physics_process(false)

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

func acabar() -> void:
	acabou.emit()
