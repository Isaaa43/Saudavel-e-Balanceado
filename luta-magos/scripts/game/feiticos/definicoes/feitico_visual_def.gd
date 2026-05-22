class_name FeiticoVisualDef
extends Resource

@export var cena: PackedScene

func criar() -> FeiticoVisual:
	var visual := FeiticoVisual.new()
	visual.visual_3d = cena.instantiate()
	visual.add_child(visual.visual_3d, true)
	
	return visual


#@export var cor: Color = Color.RED
#@export var escala: float = 1.0

#@export var parametros: Dictionary = {
	#"cor_base": Color.RED,
	#"escala": 1.0,
#}


#@export var forma: 	FormaFeitico		# mesh
#@export var trilha: 	TrilhaFeitico		# particulas trail config
#@export var efeito: 	EfeitoFeitico		# efeito ao atingir o alvo

#class_name FormaFeitico
#extends Resource
#
#@export var malha: Mesh                  # SphereMesh, BoxMesh, custom
#@export var material: ShaderMaterial     
