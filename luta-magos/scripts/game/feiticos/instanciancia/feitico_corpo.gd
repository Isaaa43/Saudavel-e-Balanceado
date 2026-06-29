class_name FeiticoCorpo
extends Node

var remote_transf_visual: RemoteTransform3D
var remote_transf_area: RemoteTransform3D

var corpo_movimento : Node3D

static func criar() -> FeiticoCorpo:
	var corpo := FeiticoCorpo.new()
	# cria o corpo de movimento
	corpo.corpo_movimento = Node3D.new()
	corpo.add_child(corpo.corpo_movimento)
	# cria os remote transforms do corpo de movimento
	corpo._criar_remote_transforms()
	return corpo

func posicao_global(global_pos: Vector3) -> void:
	corpo_movimento.global_position = global_pos

func _criar_remote_transforms() -> void:
	remote_transf_visual = RemoteTransform3D.new()
	remote_transf_area = RemoteTransform3D.new()
	corpo_movimento.add_child(remote_transf_visual)
	corpo_movimento.add_child(remote_transf_area)

func set_visual_transform(visual: Node3D) -> void:
	remote_transf_visual.remote_path = visual.get_path()

func set_area_transform(area: Node3D) -> void:
	remote_transf_area.remote_path = area.get_path()
