@abstract
class_name FeiticoEfeito
extends RefCounted

enum Tipo {INSTANTANEO, DURACAO, PERSISTENTE}

var tipo := Tipo.INSTANTANEO

@abstract
func aplicar(jogador: Jogador) -> void
