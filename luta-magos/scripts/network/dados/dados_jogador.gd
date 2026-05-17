class_name DadosJogador
extends Resource

var peer_id: int = -1
var nome: String = ""
var grimorio: Array = []
var stats: Dictionary = {}

func to_dict() -> Dictionary:
	return {
		"peer_id":		peer_id,
		"nome": 		nome,
		"grimorio":		grimorio,
		"stats":		stats,
	}

static func from_dict(d: Dictionary) -> DadosJogador:
	var dados = DadosJogador.new()
	dados.peer_id	= d.get("peer_id", -1)
	dados.nome 		= d.get("nome", "")
	dados.grimorio	= d.get("grimorio", [])
	dados.stats		= d.get("stats", {})
	return dados
