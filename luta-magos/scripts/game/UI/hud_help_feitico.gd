class_name HudHelpFeitico
extends Control

@onready var texture_rect: TextureRect = $VBoxContainer/TextureRect
@onready var label_nome: Label = $VBoxContainer/LabelNome
@onready var label_descricao: Label = $VBoxContainer/LabelDescricao

func set_feitico(feitico_def: FeiticoDef) -> void:
	texture_rect.texture = feitico_def.icone_hud
	label_nome.text = feitico_def.nome
	label_descricao.text = feitico_def.descricao
