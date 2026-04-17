class_name LancadorFeiticos
extends Node3D

@export var spell_registry: RegistroFeiticos

var _cooldowns: Dictionary = {}

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("acao"):
		cast_spell("BolaFogo", global_position)

func _process(delta: float) -> void:
	for id in _cooldowns:
		_cooldowns[id] = maxf(0.0, _cooldowns[id] - delta)

# Main entry point — call this locally AND replicate over network
func cast_spell(spell_id: String, target_pos: Vector3, target_node: Node3D = null) -> void:
	NetworkClient.lancar_feitico(spell_id, target_pos, target_node)
	#
	#var definition = spell_registry.get_feitico(spell_id)
	#if not definition or _cooldowns.get(spell_id, 0.0) > 0.0:
		#return
#
	#_cooldowns[spell_id] = definition.cooldown
#
#
	#var spell: Feitico = definition.feitico_scene.instantiate()
	##get_tree().current_scene.add_child(spell)
	#add_child(spell)
#
	#spell.feitico_id       = spell_id
	#spell.criador         = get_parent()
	#spell.direcao = target_pos
	#spell.alvo    = target_node
#
	#spell.lancar()

# Serialize to send over ENet
func build_cast_packet(spell_id: String, target_pos: Vector3) -> Dictionary:
	return {
		"type":       "cast",
		"spell_id":   spell_id,
		"caster_id":  get_parent().name,
		"target_pos": { "x": target_pos.x, "y": target_pos.y, "z": target_pos.z },
	}

# Reconstruct and cast from a received packet
func cast_from_packet(packet: Dictionary) -> void:
	var pos = packet["target_pos"]
	cast_spell(
		packet["spell_id"],
		Vector3(pos["x"], pos["y"], pos["z"])
	)
