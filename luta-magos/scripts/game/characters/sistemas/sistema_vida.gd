class_name SistemaVida
extends Node

## Quando ocorre mudanca na vida, com porcentagem total da vida maxima [0.0, 1.0] 
signal mudanca_vida(porcent: float)

# TODO: somente teste, remover
@onready var label_dano: Label3D = $LabelDano

@export var vida_max : float = 150

var vida : float

func levar_dano(dano: float) -> void:
	print('Levar dano %d' % dano)
	
	label_dano.text = "Dano:\n%d" % dano
	label_dano.show()
	get_tree().create_timer(1.2).timeout.connect( func(): label_dano.hide() )
	
	vida = max(0, vida - dano)
	
	var porcent : float = float(vida) / vida_max
	mudanca_vida.emit(porcent)
	
	_verificar_morte()

func _verificar_morte() -> void:
	if vida == 0:
		morrer()

func morrer() -> void:
	await get_tree().create_timer(0.5).timeout
	TrocaCenaTemp.go_to_menu_inicial()
