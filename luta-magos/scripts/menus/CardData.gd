extends Resource
class_name CardData

# CardData é um Resource usado para armazenar os dados de uma carta.
# Cada carta do jogo pode ser criada como um arquivo .tres baseado nesse script.

# Nome exibido da carta.
@export var nome: String

# Custo da carta.
# Pode representar mana, energia, ação ou outro recurso do jogo.
@export var custo: int

# Tipo da carta.
# Exemplos: Ataque, Defesa, Magia, Suporte etc.
@export var tipo: String

# Texto descritivo da carta.
# @export_multiline permite editar esse campo com várias linhas no Inspector.
@export_multiline var descricao: String

# Ícone ou imagem da carta exibida na interface.
@export var icone: Texture2D
