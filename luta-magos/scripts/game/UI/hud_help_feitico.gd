class_name HudHelpFeitico
extends Control

@onready var texture_rect: TextureRect = $VBoxContainer/TextureRect
@onready var label_nome: Label = $VBoxContainer/LabelNome
@onready var label_descricao: Label = $VBoxContainer/LabelDescricao

func set_feitico(feitico_card: MenuDeck.CardData) -> void:
	texture_rect.texture = feitico_card.icone
	label_nome.text = feitico_card.nome
	label_descricao.text = feitico_card.descricao
	# remove quebra de linhas
	label_descricao.text = label_descricao.text.replace("\n", " ")
