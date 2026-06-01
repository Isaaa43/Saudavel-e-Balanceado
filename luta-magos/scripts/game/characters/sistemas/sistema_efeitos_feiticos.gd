class_name SistemaEfeitosFeiticos
extends Node

@export var jogador: Jogador

var efeitos_mantidos: Array[DadosEfeito]

func receber_feitico_efeito(feitico_efeito: FeiticoEfeito) -> void:
	_criar_dados_efeito(feitico_efeito)

func _criar_dados_efeito(efeito: FeiticoEfeito) -> void:
	# TODO: Trocar para aplicar modificador
	if (efeito.modificador is FeiticoModificadorEfeitoDuradouro):
		var modificador : FeiticoModificadorEfeitoDuradouro = efeito.modificador 
		efeito.tipo = modificador.novo_tipo_efeito
	
	match (efeito.tipo):
		FeiticoEfeito.Tipo.INSTANTANEO:
			efeito.aplicar(jogador)
		FeiticoEfeito.Tipo.DURACAO:
			_criar_dados_efeito_duradouros(efeito, false)
		FeiticoEfeito.Tipo.PERSISTENTE:
			_criar_dados_efeito_duradouros(efeito, true)

func _criar_dados_efeito_duradouros(efeito: FeiticoEfeito, persistente: bool) -> void:
	# se nao tiver modificador do tipo duradouro, pare
	if not efeito.has_modificador(): return
	if not (efeito.modificador is FeiticoModificadorEfeitoDuradouro): return
	# cria o DadosEfeitoMantido do modificador duradouro
	var modificador : FeiticoModificadorEfeitoDuradouro = efeito.modificador
	var dados_mantido : DadosEfeitoMantido = DadosEfeitoMantido.new(efeito)
	# FeiticoEfeito.Tipo.PERSISTENTE
	if persistente:
		dados_mantido.set_persistente_cooldown(modificador.cooldown)
	# FeiticoEfeito.Tipo.DURACAO
	else:
		dados_mantido.set_usos(modificador.cooldown, modificador.usos)
	# conecta o sinal de acabou o efeito
	dados_mantido.acabou.connect(remover_efeito_mantido.bind(dados_mantido))
	# adiciona na lista de efeitos mantidos
	efeitos_mantidos.append(dados_mantido)


# -----------------------------------------------------------------------------
func remover_efeito_mantido(dados_efeito: DadosEfeitoMantido) -> void:
	call_deferred("_remover_efeito_mantido", dados_efeito)

func _remover_efeito_mantido(dados_efeito: DadosEfeitoMantido) -> void:
	efeitos_mantidos.erase(dados_efeito)

# -----------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	for dados_efeito : DadosEfeitoMantido in efeitos_mantidos:
		dados_efeito.passar_cooldown(delta)
		dados_efeito.tentar_executar_efeito(jogador)


# =============================================================================
# Classe: Dados do Efeito
# =============================================================================
class DadosEfeito:
	extends RefCounted
		
	var efeito : FeiticoEfeito
	
	func _init(_efeito: FeiticoEfeito) -> void:
		efeito = _efeito
		

# =============================================================================
# Classe: Dados do Efeito - Mantidos
# =============================================================================
class DadosEfeitoMantido:
	extends DadosEfeito
	
	signal acabou
	
	# quantidade de usos restantes
	var usos: int = 1
	var infinito: bool = false : 
		set(_infinito):
			infinito = _infinito
			if infinito: usos = 1
	
	# cooldown
	var cooldown_seg: float = 1.0
	
	var curr_cooldown_seg: float = 0.0
	
	func set_persistente_cooldown(_cooldown_seg: float = 1.0) -> void:
		infinito = true
		cooldown_seg = _cooldown_seg
	
	func set_cooldown(_cooldown_seg: float = 1.0, _usos: int = 1) -> void:
		infinito = false
		cooldown_seg = _cooldown_seg
		usos = _usos
	
	func tentar_executar_efeito(jogador: Jogador) -> void:
		# se terminou o cooldown, aplique o efeito
		if curr_cooldown_seg <= 0.0:
			executar_efeito(jogador)
	
	func executar_efeito(jogador: Jogador) -> void:
		# se ainda esta no cooldown, pare
		if curr_cooldown_seg > 0.01: return
		# se nao tiver mais usos, acabe
		if usos <= 0:
			acabar()
			return
		
		# aplica o efeito
		efeito.aplicar(jogador)
		# renova o cooldown
		curr_cooldown_seg = cooldown_seg
		# gasta um uso, se for
		if not infinito:
			usos -= 1
			if usos <= 0: acabar()
	
	func passar_cooldown(tempo_seg: float) -> void:
		curr_cooldown_seg -= tempo_seg
	
	func acabar() -> void:
		acabou.emit()
