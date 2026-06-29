class_name FeiticoCorpoDef
extends Resource

enum CorpoTipo {NODE3D, RIGID_BODY}

@export var tipo_corpo := CorpoTipo.NODE3D

@export var physics_mat : PhysicsMaterial

func criar() -> FeiticoCorpo:
	var corpo : FeiticoCorpo
	match (tipo_corpo):
		CorpoTipo.NODE3D:
			corpo = FeiticoCorpo.criar()
		CorpoTipo.RIGID_BODY:
			corpo = FeiticoCorpoRigidBody.criar()
			corpo.corpo_movimento.physics_material_override = physics_mat
		_:
			corpo = FeiticoCorpo.criar()
	return corpo
