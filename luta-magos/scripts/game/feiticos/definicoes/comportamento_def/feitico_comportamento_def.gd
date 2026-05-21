@abstract
class_name FeiticoComportamentoDef
extends Resource

@export_group("Comportamento")
## Tempo em segundos que o feitico existe no mapa.
## 		Valores menores que 0.1 deixam vivos indefinidamente
@export var duracao_seg: float

func criar() -> FeiticoComportamento:
	return null
