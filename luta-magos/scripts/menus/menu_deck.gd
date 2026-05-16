extends Control

@onready var deck_container = $PanelContainer/HBoxContainer/Esquerda/GridContainer
@onready var catalogo_container = $PanelContainer/HBoxContainer/Meio/GridContainer
@onready var info_panel = $PanelContainer/HBoxContainer/Direita

var deck_atual = []  # IDs das cartas no seu deck
var catalogo_cartas = []  # Todas cartas disponíveis
var carta_selecionada = null
