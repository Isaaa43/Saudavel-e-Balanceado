class_name FeiticoAreaAtivacao
extends Area3D


func _ready() -> void:
	_criar_area()

func _criar_area() -> void:
	
	var col := CollisionShape3D.new()
	var sphere_shape := SphereShape3D.new()
	sphere_shape.radius = 0.6
	col.shape = sphere_shape
	add_child(col)
	
	#force_area_update()
	
	body_entered.connect(func(x): print("entrou ", x))
	
