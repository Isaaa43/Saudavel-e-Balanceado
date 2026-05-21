class_name NetworkLogs
extends Node

signal update_conexao_texto(texto)

var conexao_historico :Array[String] = [] :
	get:
		return conexao_historico

func add_conexao_texto(txt: String) -> void:
	conexao_historico.append(txt)
	update_conexao_texto.emit(txt)

func add_conexao_texto_peer(txt: String, peer_id: int) -> void:
	txt += " (id: %d)" % peer_id
	add_conexao_texto(txt)

func add_texto(txt: String) -> void:
	
	pass
