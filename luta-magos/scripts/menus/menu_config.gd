extends Control

@onready var spin_box_port: SpinBox = $GridContainer/SpinBoxPort

# Ready
# -----------------------------------------------------------------------------

func _ready() -> void:
	spin_box_port.set_value_no_signal(Network.PORT)

# Sair
# -----------------------------------------------------------------------------

func _on_button_voltar_pressed() -> void:
	TrocaCenaTemp.go_to_menu_inicial()

# -----------------------------------------------------------------------------
# Configs
# -----------------------------------------------------------------------------

# Tela
# -----------------------------------------------------------------------------

func _on_button_cheia_pressed() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_button_janela_pressed() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


# Conexao
# -----------------------------------------------------------------------------

func _on_spin_box_value_changed(value: float) -> void:
	var port : int = int(value)
	Network.PORT = port


# Reset
# -----------------------------------------------------------------------------

func _on_button_reset_pressed() -> void:
	Network.PORT = Network.PORT_DEFAULT
	spin_box_port.set_value_no_signal(Network.PORT)
