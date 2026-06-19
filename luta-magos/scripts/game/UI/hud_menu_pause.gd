class_name HudMenuPause
extends Control

signal voltar_partida
signal sair_partida
signal sensibilidade_mira_atualizada

@onready var label_sensi_valor: Label = $Tamanho/Panel/Margin/VBox/HScrollSensi/LabelSensiValor

func _on_h_scroll_sensi_value_changed(value: float) -> void:
	sensibilidade_mira_atualizada.emit(value)
	label_sensi_valor.text = "%.2f" % value

func _on_button_voltar_pressed() -> void:
	voltar_partida.emit()

func _on_button_sair_pressed() -> void:
	sair_partida.emit()
