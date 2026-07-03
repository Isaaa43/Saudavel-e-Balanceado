class_name MenuCreditos
extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Sair
# -----------------------------------------------------------------------------

func _on_button_voltar_pressed() -> void:
	TrocaCenaTemp.go_to_menu_inicial()
