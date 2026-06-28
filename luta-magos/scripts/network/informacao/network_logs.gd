class_name NetworkLogs
extends Node

signal update_conexao

var historico_logs : Array[String] = []

# Manejar a Lista de Logs
# -----------------------------------------------------------------------------

func _add_log(texto : String) -> void:
	historico_logs.append(texto)

func _last_logs(num: int) -> Array[String]:
	var start_i: int = historico_logs.size() - num if (historico_logs.size() >= num) else 0
	return historico_logs.slice(start_i)

# Pegar os Logs recentes
# -----------------------------------------------------------------------------

func get_recent_logs_string(num: int = 10) -> String:
	var texto := ""
	for txt: String in _last_logs(num):
		texto += txt + '\n'
	return texto

# Updates da Conexao
# -----------------------------------------------------------------------------

func add_conexao_texto(txt: String) -> void:
	_add_log(txt)
	update_conexao.emit()

func add_conexao_texto_peer(txt: String, peer_id: int) -> void:
	txt += " (id: %d)" % peer_id
	add_conexao_texto(txt)
