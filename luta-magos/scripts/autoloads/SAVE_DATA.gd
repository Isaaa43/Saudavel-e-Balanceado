# match_recorder.gd (autoload: MatchRecorder)
extends Node

# --- config ---
const POSICAO_INTERVALO := 0.5          # record position every 0.5s
const PASTA := "user://replays/"

# --- internal state ---
var _partida_id: String = ""
var _tempo: float = 0.0
var _gravando: bool = false
var _timer_posicao: float = 0.0

# --- data buffers (one array per event type) ---
var _posicoes:  PackedStringArray = PackedStringArray()
var _feiticos:  PackedStringArray = PackedStringArray()
var _mortes:    PackedStringArray = PackedStringArray()
var _nomes: PackedStringArray = PackedStringArray()

# --- headers ---
const HEADER_POSICAO  := "tempo,entidade_id,x,y,z"
const HEADER_FEITICO  := "tempo,criador_id,feitico_id,alvo_id,pos_x,pos_y,pos_z"
const HEADER_MORTE    := "tempo,entidade_id,causa,atacante_id"
const HEADER_NOMES := "entidade_id,peer_id,nome"

# --- lifecycle ---

func iniciar_partida(partida_id: String = "") -> void:
	if not multiplayer.is_server(): return
	
	_partida_id = partida_id if partida_id != "" else _gerar_id()
	_tempo = 0.0
	_timer_posicao = 0.0
	_gravando = true
	_nomes = PackedStringArray([HEADER_NOMES])
	_posicoes  = PackedStringArray([HEADER_POSICAO])
	_feiticos  = PackedStringArray([HEADER_FEITICO])
	_mortes    = PackedStringArray([HEADER_MORTE])
	DirAccess.make_dir_recursive_absolute(PASTA)

func encerrar_partida() -> void:
	if not _gravando: return
	_gravando = false
	_salvar_tudo()

func _process(delta: float) -> void:
	if not _gravando: return
	_tempo += delta

# --- public recording API ---

func registrar_nome(entidade_id: int, nome: String) -> void:
	_nomes.append("n,%d,%d,%s" % [entidade_id, nome])

func registrar_posicao(entidade_id: int, posicao: Vector3, rotacao_y: float, cabeca_rot: float) -> void:
	if not _gravando: return
	_posicoes.append("p,%s,%d,%.3f,%.3f,%.3f,%.2f,%.2f" % [
		_fmt_tempo(), entidade_id,
		posicao.x, posicao.y, posicao.z,
		rotacao_y, cabeca_rot
	])

func registrar_feitico(criador_id: int, feitico_id: String,
						posicao: Vector3, direcao: Vector3) -> void:
	if not _gravando: return
	_feiticos.append("f,%s,%d,%s,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f" % [
		_fmt_tempo(), criador_id, feitico_id,
		posicao.x, posicao.y, posicao.z,
		direcao.x, direcao.y, direcao.z,
	])

func registrar_morte(entidade_id: int, posicao: Vector3) -> void:
	if not _gravando: return
	_mortes.append("m,%s,%d,%.3f,%.3f,%.3f" % [
		_fmt_tempo(), entidade_id,
		posicao.x, posicao.y, posicao.z
	])

# --- physics tick helper (call from your game scene or player) ---
# lets each entity register its own position on the shared timer

var _entidades_registradas: Array[Callable] = []

func registrar_entidade(callback: Callable) -> void:
	_entidades_registradas.append(callback)

func desregistrar_entidade(callback: Callable) -> void:
	_entidades_registradas.erase(callback)

func _physics_process(delta: float) -> void:
	if not _gravando: return
	_timer_posicao += delta
	if _timer_posicao >= POSICAO_INTERVALO:
		_timer_posicao = 0.0
		for cb in _entidades_registradas:
			cb.call()

# --- file writing ---

func _salvar_tudo() -> void:
	var base := PASTA + _partida_id + "_"
	_escrever_csv(base + "posicoes.csv",  _posicoes)
	_escrever_csv(base + "feiticos.csv",  _feiticos)
	_escrever_csv(base + "mortes.csv",    _mortes)
	print("[MatchRecorder] salvo em: ", PASTA, _partida_id)

func _escrever_csv(caminho: String, linhas: PackedStringArray) -> void:
	var f := FileAccess.open(caminho, FileAccess.WRITE)
	if not f:
		push_error("[MatchRecorder] erro ao abrir: " + caminho)
		return
	f.store_string("\n".join(linhas))
	f.close()

func _fmt_tempo() -> String:
	return "%.3f" % _tempo

func _gerar_id() -> String:
	return Time.get_datetime_string_from_system().replace(":", "-")
