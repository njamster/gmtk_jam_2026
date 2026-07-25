extends Node

enum GameState {
	MAIN_MENU,
	RUNNING,
	PAUSED,
	GAME_OVER
}

signal game_state_changed(state: GameState)

var game_state := GameState.MAIN_MENU:
	set(value):
		game_state = value
		game_state_changed.emit(value)

var tilemap: TileMapLayer
var camera: Camera2D

var tile_size

var num_players := 2
var num_enemies := 0

var num_alive_players := num_players

# cheat codes :D
var decay_enabled := true
var auto_move := true

# stats
var stats: Array[Dictionary]

var survival_time := 0.0


func _ready() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_HIDDEN#

	_load_settings()

	for i in num_players:
		stats.append({
			"survival_time": 0.0,
			"jumps": 0,
			"gold": 0,
			"death_reason": "",
		})

	survival_time = 0.0


func _load_settings() -> void:
	var settings_file = ConfigFile.new()
	var error := settings_file.load("user://settings.cfg")

	if error:
		return  # early

	for i in AudioServer.bus_count:
		AudioServer.set_bus_volume_linear(
			i,
			clampf(
				settings_file.get_value("Audio", AudioServer.get_bus_name(i), 1.0),
				0.0,
				1.0
			)
		)


func _process(delta: float) -> void:
	survival_time += delta


func _unhandled_input(event: InputEvent) -> void:
	if OS.is_debug_build():
		if event is InputEventKey and event.keycode == KEY_SHIFT:
			if event.pressed:
				Engine.time_scale = 5.0
			else:
				Engine.time_scale = 1.0


func reset_stats() -> void:
	for i in num_players:
		stats[i] = {
			"survival_time": 0.0,
			"jumps": 0,
			"gold": 0,
			"death_reason": "",
		}

	survival_time = 0.0

	num_alive_players = num_players
