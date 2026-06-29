class_name FeiticoCorpoRigidBody
extends FeiticoCorpo

static func criar() -> FeiticoCorpoRigidBody:
	var corpo := FeiticoCorpoRigidBody.new()
	# cria o corpo de movimento
	corpo.corpo_movimento = corpo._criar_rigid_body()
	corpo.add_child(corpo.corpo_movimento)
	# cria os remote transforms do corpo de movimento
	corpo._criar_remote_transforms()
	return corpo

func _criar_rigid_body() -> RigidBody3D:
	var rigid_body := RigidBody3D.new()
	
	rigid_body.collision_layer = 0
	rigid_body.set_collision_layer_value(1, true)
	rigid_body.set_collision_layer_value(17, true)
	rigid_body.set_collision_layer_value(18, true)
	
	rigid_body.collision_mask = 0
	rigid_body.set_collision_mask_value(2, true)
	rigid_body.set_collision_mask_value(3, true)
	rigid_body.set_collision_mask_value(5, true)
	
	var coll := CollisionShape3D.new()
	coll.shape = SphereShape3D.new()
	rigid_body.add_child(coll)
	
	return rigid_body
