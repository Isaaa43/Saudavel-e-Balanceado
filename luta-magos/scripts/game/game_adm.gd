extends Node

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		NetworkServer.terminar_partida()
