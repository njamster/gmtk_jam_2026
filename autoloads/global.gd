extends Node

var tilemap: TileMap

var tile_size := 32

var num_players := 2
var num_enemies := 20

# cheat codes :D
var decay_enabled := true
var auto_move := true

# stats
var stats: Array[Dictionary]


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

	for i in num_players:
		stats.append({
			"jumps": 0
		})


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
		reset_stats()
	elif event.is_action_pressed("toggle_mute"):
		var master_id := AudioServer.get_bus_index("Master")
		AudioServer.set_bus_mute(master_id, not AudioServer.is_bus_mute(master_id))


func reset_stats() -> void:
	for i in num_players:
		stats[i] = {
			"jumps": 0
		}
