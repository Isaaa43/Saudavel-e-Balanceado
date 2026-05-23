@abstract
class_name FeiticoComportamentoDef
extends Resource

# -----------------------------------------------------------------------------
@export_group("Duracao")
## Tempo em segundos que o feitico existe no mapa.
## 		(Valores menores que 0.1 deixam vivos indefinidamente)
@export var duracao_seg: float

# -----------------------------------------------------------------------------
@export_group("Efeitos")
## Quem pode ser afetado pelos efeitos
@export var afetados := FeiticoComportamento.Afetados.TODOS
## Mascara de colisao de fisica3D, contendo quem eh detectado
## e afetado pelo comportamento, quem vai receber os efeitos 
@export_flags_3d_physics var mascara_afetados = 256

@export var efeitos: Array[FeiticoEfeitoDef]

# -----------------------------------------------------------------------------
@export_group("Visual")
@export var visual_def: FeiticoVisualDef

func criar() -> FeiticoComportamento:
	# --- cria o comportamento especifico
	var comportamento : FeiticoComportamento = _criar()
	_criar_sub_sistemas(comportamento)
	# --- efeitos
	comportamento.afetados = afetados
	comportamento.mask_afetados = mascara_afetados
	for efeito_def : FeiticoEfeitoDef in efeitos:
		comportamento.efeitos.append(efeito_def.criar())
	# --- retorna o comportamento especifico criado
	return comportamento

@abstract
func _criar() -> FeiticoComportamento

func _criar_sub_sistemas(comportamento: FeiticoComportamento) -> void:
	comportamento.visual = visual_def.criar()
	comportamento.area_ativacao = FeiticoAreaAtivacao.new()
	comportamento.corpo = FeiticoCorpo.criar()
