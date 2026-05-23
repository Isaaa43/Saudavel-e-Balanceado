class_name FeiticoCorpo
extends Node3D

var remote_transf_visual: RemoteTransform3D
var remote_transf_area: RemoteTransform3D

static func criar() -> FeiticoCorpo:
	var corpo := FeiticoCorpo.new()
	
	corpo._criar_remote_transforms()
	corpo._criar_area()
	
	return corpo

# TODO: trocar para uma classe propria
var area: Area3D
func _criar_area() -> void:
	area = Area3D.new()
	add_child(area)
	
	var col := CollisionShape3D.new()
	var sphere_shape := SphereShape3D.new()
	sphere_shape.radius = 0.6
	col.shape = sphere_shape
	area.add_child(col)
	
	#area.force_area_update()
	
	area.body_entered.connect(func(x): print("entrou ", x))

func _criar_remote_transforms() -> void:
	remote_transf_visual = RemoteTransform3D.new()
	remote_transf_area = RemoteTransform3D.new()
	add_child(remote_transf_visual)
	add_child(remote_transf_area)

func set_visual_transform(visual: Node) -> void:
	remote_transf_visual.remote_path = visual.get_path()

func set_area_transform(area: Node) -> void:
	remote_transf_area.remote_path = area.get_path()
