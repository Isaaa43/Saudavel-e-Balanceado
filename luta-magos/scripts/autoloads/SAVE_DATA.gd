extends Node

# Tracked data
var player_positions: Dictionary = {}  # {player_id: Array of Vector3}
var match_start_time: float = 0.0
var is_recording: bool = false
var match_id: String = ""

# File settings
var save_directory: String = "user://match_data/"
var current_file_path: String = ""

func _ready():
	# Create directory if it doesn't exist
	ensure_directory_exists(save_directory)

func start_recording():
	is_recording = true
	match_start_time = Time.get_ticks_msec() / 1000.0
	match_id = get_timestamp_string()
	player_positions.clear()
	
	# Create CSV file
	current_file_path = save_directory + "match_%s.csv" % match_id
	create_csv_header()
	
	print("Started recording player positions - Match ID: ", match_id)

func stop_recording():
	if not is_recording:
		return
	
	is_recording = false
	
	# Save remaining data
	save_to_csv()
	
	print("Stopped recording. Data saved to: ", current_file_path)
	print("Total tracked frames per player:")
	for player_id in player_positions:
		print("Player %d: %d positions" % [player_id, player_positions[player_id].size()])

func _physics_process(delta):
	if not is_recording:
		return
	
	# Track all players in the scene
	track_all_players()


func track_spells(contexto: FeiticoContexto) -> void:
	pass

var jogadores: Array[Jogador]
var players: Array[JogadorCorpo]
var player_by_id: Dictionary[int, JogadorCorpo]
func set_players(jogadores_list: Array[Jogador]) -> void:
	jogadores = jogadores_list.duplicate()
	
	players.resize(jogadores.size())
	for i in range(jogadores.size()):
		players[i] = jogadores[i].jogador_corpo
		player_by_id[int(jogadores[i].name)] = players[i]

func track_all_players():
	var current_time = Time.get_ticks_msec() / 1000.0 - match_start_time
	
	for player_id: int in player_by_id:
		var player : JogadorCorpo = player_by_id[player_id]
		var position = player.global_position
		var rotation = player.rotation.y
		var head_rotation = player.cabeca_pivot.rotation.z
		
		add_position_data(player_id, position, rotation, head_rotation, current_time)

func add_position_data(player_id: int, 
						position: Vector3, 
						rotation: float, 
						head_rotation: float, 
						timestamp: float):
	if not player_positions.has(player_id):
		player_positions[player_id] = []
	
	# Store position with timestamp
	player_positions[player_id].append({
		"time": timestamp,
		"x": position.x,
		"y": position.y,
		"z": position.z,
		"rot": rotation,
		"h_rot": head_rotation,
	})

func create_csv_header():
	var file = FileAccess.open(current_file_path, FileAccess.WRITE)
	if file:
		# Create header
		var header = "timestamp,player_id,pos_x,pos_y,pos_z\n"
		file.store_string(header)
		file.close()
	else:
		print("Error creating CSV file: ", current_file_path)

func save_to_csv():
	if player_positions.is_empty():
		print("No data to save")
		return
	
	var file = FileAccess.open(current_file_path, FileAccess.READ_WRITE)
	if not file:
		print("Error opening file for writing")
		return
	
	# Move to end of file
	file.seek_end()
	
	# Write all positions
	for player_id in player_positions:
		for pos_data in player_positions[player_id]:
			var line = "%f,%d,%f,%f,%f\n" % [
				pos_data["time"],
				player_id,
				pos_data["x"],
				pos_data["y"],
				pos_data["z"],
				pos_data["rot"],
				pos_data["h_rot"],
			]
			file.store_string(line)
	
	file.close()
	print("Saved %d entries to CSV" % get_total_entries())

func get_total_entries() -> int:
	var total = 0
	for player_id in player_positions:
		total += player_positions[player_id].size()
	return total

func get_timestamp_string() -> String:
	var datetime = Time.get_datetime_dict_from_system()
	return "%04d%02d%02d_%02d%02d%02d" % [
		datetime.year, datetime.month, datetime.day,
		datetime.hour, datetime.minute, datetime.second
	]

func ensure_directory_exists(path: String):
	var dir = DirAccess.open("user://")
	if not dir.dir_exists("match_data"):
		dir.make_dir("match_data")

# Manual position recording (useful for specific tracking)
func record_position(player_id: int, position: Vector3, timestamp: float = -1):
	if not is_recording:
		return
	
	if timestamp < 0:
		timestamp = Time.get_ticks_msec() / 1000.0 - match_start_time
	
	add_position_data(player_id, position, timestamp)

# Get tracked data (for debugging)
func get_player_positions(player_id: int) -> Array:
	if player_positions.has(player_id):
		return player_positions[player_id]
	return []

func get_all_data() -> Dictionary:
	return player_positions.duplicate(true)

# Export additional data (like match results, winner, etc.)
func save_match_metadata(metadata: Dictionary):
	if not current_file_path:
		return
	
	var meta_path = current_file_path.replace(".csv", "_metadata.json")
	var file = FileAccess.open(meta_path, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(metadata)
		file.store_string(json_string)
		file.close()
		print("Saved metadata to: ", meta_path)

func clear_data():
	player_positions.clear()
	is_recording = false
