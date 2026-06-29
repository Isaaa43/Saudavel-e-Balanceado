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

func append_logs(logs: Array[String]) -> void:
	historico_logs.append_array(logs)
	update_conexao.emit()

# Pegar os Logs recentes
# -----------------------------------------------------------------------------

func get_recent_logs_list(num: int = 10) -> Array[String]:
	return _last_logs(num)

func get_recent_logs_string(num: int = 10) -> String:
	var texto := ""
	for txt: String in _last_logs(num):
		texto += txt + '\n'
	return texto

## Logs em formato BBCode
## -----------------------------------------------------------------------------
#
#func get_recent_logs_bbcode(num: int = 10) -> String:
	#var texto := ""
	#for txt: String in _last_logs(num):
		#texto += _converter_log_bbcode(txt) + '\n'
	#return texto
#
### Converte o texto em bbcode de um evento associado
#func _converter_log_bbcode(texto: String) -> String:
	#texto = texto.format({})
	#return texto

# Updates da Conexao
# -----------------------------------------------------------------------------

func add_conexao_texto(txt: String) -> void:
	_add_log(txt)
	update_conexao.emit()

func add_conexao_texto_peer(txt: String, peer_id: int) -> void:
	txt += " (id: %d)" % peer_id
	add_conexao_texto(txt)
