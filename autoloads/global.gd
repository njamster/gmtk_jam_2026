extends Node

enum GameState {
	RUNNING,
	PAUSED,
	GAME_OVER
}

@warning_ignore("unused_signal")
signal game_state_changed(state: GameState)

var tilemap: TileMapLayer

var tile_size := 32

var num_players := 2
var num_enemies := 20

var num_alive_players := num_players

# cheat codes :D
var decay_enabled := true
var auto_move := true

# stats
var stats: Array[Dictionary]

var survival_time := 0.0


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

	for i in num_players:
		stats.append({
			"survival_time": 0.0,
			"jumps": 0,
			"death_reason": "",
		})

	survival_time = 0.0


func _process(delta: float) -> void:
	survival_time += delta


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
			"survival_time": 0.0,
			"jumps": 0,
			"death_reason": "",
		}

	survival_time = 0.0

	num_alive_players = num_players
