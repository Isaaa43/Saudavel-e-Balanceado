@abstract
class_name FeiticoComportamentoDef
extends Resource

@export_group("Comportamento")
## Tempo em segundos que o feitico existe no mapa.
## 		Valores menores que 0.1 deixam vivos indefinidamente
@export var duracao_seg: float

@export_group("Visual")
@export var visual_def: FeiticoVisualDef

func criar() -> FeiticoComportamento:
	var comportamento : FeiticoComportamento = _criar()
	_criar_sub_sistemas(comportamento)
	return comportamento

@abstract
func _criar() -> FeiticoComportamento

func _criar_sub_sistemas(comportamento: FeiticoComportamento) -> void:
	comportamento.visual = visual_def.criar()
	comportamento.corpo = FeiticoCorpo.criar()
	
