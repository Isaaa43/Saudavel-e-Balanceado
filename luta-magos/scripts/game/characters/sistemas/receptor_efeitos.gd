class_name ReceptorEfeitos
extends Node

@export var sistema_vida: SistemaVida
@export var sistema_mana: SistemaMana
@export var sistema_efeitos: SistemaEfeitosFeiticos

var cura_desativada: bool = false

static func encontrar_receptor_efeitos(nodo: Node) -> ReceptorEfeitos:
	var receptor : ReceptorEfeitos = nodo.get("receptor_efeitos")
	if receptor != null and receptor is ReceptorEfeitos: return receptor
	# else
	return nodo.find_child("ReceptorEfeitos")

 
func receber_lista_efeitos(lista_efeitos: Array[FeiticoEfeito]) -> void:
	for efeito: FeiticoEfeito in lista_efeitos:
		receber_efeito(efeito)

func receber_efeito(efeito: FeiticoEfeito) -> void:
	# se a cura estiver desativa, e for uma cura, pare e nao aplique o efeito
	if cura_desativada:
		if efeito is FeiticoEfeitoCura: return
	# aplica o efeito
	sistema_efeitos.receber_feitico_efeito(efeito)

## Desativa as curas
func desativar_cura() -> void:
	cura_desativada = true
