class_name CardGridItem
extends Button

signal card_selected(card: MenuDeck.CardData)
signal card_activated(card: MenuDeck.CardData)

var card_data: MenuDeck.CardData = null

@onready var card_icon: TextureRect = %CardIcon
@onready var card_name_label: Label = %CardNameLabel
@onready var card_cost_label: Label = %CardCostLabel

@onready var color_background: ColorRect = $MarginContainer/ColorBackground

@export var cor_projetil: Color
@export var cor_posicionado: Color
@export var cor_efeito: Color

func _ready() -> void:
	pressed.connect(_on_pressed)


func setup(card: MenuDeck.CardData) -> void:
	card_data = card
	
	card_name_label.text = card.nome
	card_cost_label.text = "Custo: %d" % card.custo
	card_icon.texture = card.icone
	
	tooltip_text = "%s\n%s" % [card.nome, card.descricao]
	
	color_background.color = _decidir_cor(card.tipo)

func _on_pressed() -> void:
	if card_data == null:
		return

	card_selected.emit(card_data)


func _gui_input(event: InputEvent) -> void:
	if card_data == null:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and event.double_click:
			card_activated.emit(card_data)

# TODO: melhorar isso
func _decidir_cor(tipo_str: String) -> Color:
	match (tipo_str):
		"Projetil":
			return cor_projetil
		"Posicionado":
			return cor_posicionado
		"Efeito":
			return cor_efeito
	return Color.DIM_GRAY
