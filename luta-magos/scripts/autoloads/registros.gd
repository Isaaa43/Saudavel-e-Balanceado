extends Node

var reg_feiticos : RegistroFeiticos

func _init() -> void:
	reg_feiticos = RegistroFeiticos.new()
	add_child(reg_feiticos)
