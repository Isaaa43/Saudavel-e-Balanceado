class_name FeiticoCorpo
extends Node3D

var remote_transf_visual: RemoteTransform3D
var remote_transf_area: RemoteTransform3D

static func criar() -> FeiticoCorpo:
	var corpo := FeiticoCorpo.new()
	
	corpo._criar_remote_transforms()
	
	return corpo

func _criar_remote_transforms() -> void:
	remote_transf_visual = RemoteTransform3D.new()
	remote_transf_area = RemoteTransform3D.new()
	add_child(remote_transf_visual)
	add_child(remote_transf_area)

func set_visual_transform(visual: Node) -> void:
	remote_transf_visual.remote_path = visual.get_path()

func set_area_transform(area: Node) -> void:
	remote_transf_area.remote_path = area.get_path()
