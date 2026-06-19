class_name TimerAdm
extends Node

signal tempo_esgotado
signal tempo_atualizado(tempo_restante_seg: float)

## Duracao da partida
@export var duracao_seg: float = 300.0

@onready var multiplayer_synchronizer: MultiplayerSynchronizer = $MultiplayerSynchronizer

## Tempo atual da partida
## [br]
## [b]Nao deve ser alterado![/b] Apenas usado para sincronizacao
@export var tempo_restante_seg: float = 0.0 :
	set(_tempo_restante_seg):
		tempo_restante_seg = _tempo_restante_seg
		tempo_atualizado.emit(tempo_restante_seg)

var rodando: bool = false

func _ready() -> void:
	# so executa a fisica se for o server
	set_physics_process(multiplayer.is_server())
	set_multiplayer_authority(Network.SERVER_ID)
	#multiplayer_synchronizer.set_multiplayer_authority(Network.SERVER_ID)

func iniciar() -> void:
	if not multiplayer.is_server(): return
	tempo_restante_seg = duracao_seg
	rodando = true

func parar() -> void:
	if not multiplayer.is_server(): return
	rodando = false

func _physics_process(delta: float) -> void:
	if not rodando: return
	# atualiza o tempo_restante
	tempo_restante_seg -= delta
	tempo_atualizado.emit(tempo_restante_seg)
	# se acabou o tempo, fim do timer
	if tempo_restante_seg <= 0.0:
		tempo_restante_seg = 0.0
		_fim_timer()

# pare, e emita tempo_esgotado
func _fim_timer() -> void:
	if not multiplayer.is_server(): return
	
	rodando = false
	tempo_esgotado.emit()
	
