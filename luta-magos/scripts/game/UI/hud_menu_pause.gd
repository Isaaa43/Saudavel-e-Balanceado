class_name HudMenuPause
extends Control

signal voltar_partida
signal sair_partida
signal sensibilidade_mira_atualizada

@onready var label_sensi_valor: Label = $Tamanho/Panel/Margin/VBox/HScrollSensi/LabelSensiValor

@onready var h_box_help_feitico: HBoxContainer = %HBoxHelpFeitico

const HUD_HELP_FEITICO = preload("uid://1bq0boade0k5")

func _on_h_scroll_sensi_value_changed(value: float) -> void:
	sensibilidade_mira_atualizada.emit(value)
	label_sensi_valor.text = "%.2f" % value

func _on_button_voltar_pressed() -> void:
	voltar_partida.emit()

func _on_button_sair_pressed() -> void:
	sair_partida.emit()

func set_feiticos(lista_feiticos_def: Array[FeiticoDef]) -> void:
	for c in h_box_help_feitico.get_children(): c.queue_free()
	# adiciona um helper para cada feitico
	for feitico_def: FeiticoDef in lista_feiticos_def:
		var help_feitico := HUD_HELP_FEITICO.instantiate() as HudHelpFeitico
		h_box_help_feitico.add_child(help_feitico)
		help_feitico.set_feitico(feitico_def)
