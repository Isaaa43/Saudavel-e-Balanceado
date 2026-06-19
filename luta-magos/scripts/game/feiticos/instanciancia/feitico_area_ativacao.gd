class_name FeiticoAreaAtivacao
extends Area3D

var raio : float = 0.5

## Camadas de fisica 3d que sao afetadas
var mask_afetados: int : 
	set(_mask_afetados):
		mask_afetados = _mask_afetados
		_update_mask()

func _init(_raio: float = 0.5) -> void:
	raio = _raio

func _ready() -> void:
	_criar_area()

func _criar_area() -> void:
	var col := CollisionShape3D.new()
	var sphere_shape := SphereShape3D.new()
	sphere_shape.radius = raio
	col.shape = sphere_shape
	add_child(col)
	
	#force_area_update()
	
	body_entered.connect(func(x): print("entrou ", x))


func set_feitico_tipo(tipo: Feitico.Tipo) -> void:
	# Layers: 
	#	Todos (L 1 = int 1), 
	#	Todos Feiticos (L 17 = int 65536)
	collision_layer = (1 + 65536)
	# ativa tambem a layer do seu tipo especificamente
	match (tipo):
		Feitico.Tipo.PROJETIL:
			# Projeteis (L 18)
			set_collision_layer_value(18, true)
		Feitico.Tipo.POSICIONADO:
			# Posicionados (L 19)
			set_collision_layer_value(19, true)
		Feitico.Tipo.EFEITO:
			# Efeitos (L 20)
			set_collision_layer_value(20, true)

func _update_mask() -> void:
	collision_mask = mask_afetados
