extends Control

@onready var spin_box_mana: SpinBox = $GridContainer/SpinBoxMana
@onready var spin_box_cartas_deck: SpinBox = $GridContainer/SpinBoxCartasDeck

func _ready() -> void:
	_display_valores()

func _display_valores() -> void:
	spin_box_mana.set_value_no_signal(GlobalDeck.treino_mana_regen)
	spin_box_cartas_deck.set_value_no_signal(GlobalDeck.treino_deck_size)

func _on_spin_box_mana_value_changed(value: float) -> void:
	GlobalDeck.treino_mana_regen = value

func _on_spin_box_cartas_deck_value_changed(value: float) -> void:
	GlobalDeck.treino_deck_size = int(value)


func _on_button_reset_pressed() -> void:
	GlobalDeck.treino_mana_regen = GlobalDeck.mana_regen
	GlobalDeck.treino_deck_size = GlobalDeck.deck_size
	_display_valores()
