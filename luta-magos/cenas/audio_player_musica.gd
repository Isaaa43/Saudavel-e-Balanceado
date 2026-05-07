extends AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play(TrocaCenaTemp.musica_player_time)
	TrocaCenaTemp.musica_player = self
