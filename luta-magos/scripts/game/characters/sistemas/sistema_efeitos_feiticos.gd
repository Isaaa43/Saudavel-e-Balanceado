class_name SistemaEfeitosFeiticos
extends Node

@export var jogador: Jogador

var efeitos_mantidos: Array[DadosEfeito]

func receber_feitico_efeito(feitico_efeito: FeiticoEfeito) -> void:
	match (feitico_efeito.tipo):
		FeiticoEfeito.Tipo.INSTANTANEO:
			feitico_efeito.aplicar(jogador)
		FeiticoEfeito.Tipo.DURACAO:
			var dados_efeito := DadosEfeito.new(feitico_efeito)
			dados_efeito.set_duracao(5.0)
			dados_efeito.acabou.connect(remover_efeito_mantido.bind(dados_efeito))
			efeitos_mantidos.append(dados_efeito)
		FeiticoEfeito.Tipo.PERSISTENTE:
			var dados_efeito := DadosEfeito.new(feitico_efeito)
			dados_efeito.set_cooldown_infinito(1.0)
			efeitos_mantidos.append(dados_efeito)

func remover_efeito_mantido(dados_efeito: DadosEfeito) -> void:
	call_deferred("_remover_efeito_mantido", dados_efeito)

func _remover_efeito_mantido(dados_efeito: DadosEfeito) -> void:
	efeitos_mantidos.erase(dados_efeito)

func _physics_process(delta: float) -> void:
	for dados_efeito : DadosEfeito in efeitos_mantidos:
		dados_efeito.passar_cooldown(delta)
		dados_efeito.tentar_executar_efeito(jogador)

class DadosEfeito:
	signal acabou
	
	var efeito : FeiticoEfeito
	# quantidade de usos restantes
	var usos: int = 1
	var infinito: bool = false : 
		set(_infinito):
			infinito = _infinito
			if infinito: usos = 1
	
	# cooldown
	var cooldown_seg: float = 1.0
	
	var curr_cooldown_seg: float = 0.0
	
	func _init(_efeito: FeiticoEfeito) -> void:
		efeito = _efeito
	
	func set_usos(_infinito: bool = false, _usos: int = 1) -> void:
		infinito = _infinito
		usos = _usos
		
	func set_cooldown_infinito(_cooldown_seg: float = 1.0) -> void:
		infinito = true
		cooldown_seg = _cooldown_seg
	
	func set_duracao(duracao_seg: float, _cooldown_seg: float = 1.0) -> void:
		infinito = false
		cooldown_seg = _cooldown_seg
		# calcula usos
		usos = int(duracao_seg / _cooldown_seg)
	
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
