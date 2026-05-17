extends Node

var reg_feiticos : RegistroFeiticos

func _init() -> void:
	reg_feiticos = RegistroFeiticos.new()
	reg_feiticos.name = "RegistroFeiticos"
	add_child(reg_feiticos, true)
