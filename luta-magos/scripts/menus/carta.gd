extends Button

signal carta_clicada(carta_data, origem)

var dados = {}  # id, nome, descricao, custo, etc
var origem = ""  # "deck" ou "catalogo"

func _ready():
	text = dados.nome
	pressed.connect(_on_pressed)

func _on_pressed():
	carta_clicada.emit(dados, origem)
