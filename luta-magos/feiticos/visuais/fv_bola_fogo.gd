extends Node3D

@onready var fogo: GPUParticles3D = $CSGSphere3D/fogo

func _ready() -> void:
	fogo.hide()
	await get_tree().create_timer(0.3).timeout
	fogo.show()
