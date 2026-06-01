class_name ReceptorEfeitos
extends Node

@export var sistema_vida: SistemaVida
@export var sistema_mana: SistemaMana
@export var sistema_efeitos: SistemaEfeitosFeiticos

var dono_id: int

static func encontrar_receptor_efeitos(nodo: Node) -> ReceptorEfeitos:
	var receptor : ReceptorEfeitos = nodo.get("receptor_efeitos")
	if receptor != null and receptor is ReceptorEfeitos: return receptor
	# else
	return nodo.find_child("ReceptorEfeitos")

 
func receber_lista_efeitos(lista_efeitos: Array[FeiticoEfeito]) -> void:
	for efeito: FeiticoEfeito in lista_efeitos:
		receber_efeito(efeito)

func receber_efeito(efeito: FeiticoEfeito) -> void:
	sistema_efeitos.receber_feitico_efeito(efeito)

#func receber_dano(valor: float) -> void:
	#if sistema_vida:
		#sistema_vida.receber_dano(valor)
#
#func receber_mana(valor: float) -> void:
	#if sistema_mana:
		#sistema_mana.ganhar_mana(valor)
