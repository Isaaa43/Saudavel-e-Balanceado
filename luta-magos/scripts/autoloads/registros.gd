extends Node

var reg_feiticos : RegistroFeiticos

## Jogador Id do Jogador Local (desse PC)
var jogador_id_local : int = -1

func _init() -> void:
	reg_feiticos = RegistroFeiticos.new()
	reg_feiticos.name = "RegistroFeiticos"
	add_child(reg_feiticos, true)
