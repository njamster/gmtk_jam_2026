extends Node

const MIN_INT := pow(-2, 63)
const MAX_INT := pow(+2, 63) - 1

enum GameState {
	MAIN_MENU,
	RUNNING,
	PAUSED,
	GAME_OVER
}

enum DeathReason {
	NONE,
	FALL,
	ENEMY
}

signal game_state_changed(state: GameState)

var game_state := GameState.MAIN_MENU:
	set(value):
		game_state = value
		if game_state == GameState.RUNNING:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		game_state_changed.emit(value)

# quick access
var tilemap: TileMapLayer
var camera: Camera2D
var player: Area2D

var tile_size

# cheat codes :D
var decay_enabled := true

var stats := {
	"survival_time": 0.0,
	"jumps": 0,
	"gold": 0,
	"death_reason": DeathReason.NONE,
}

var survival_time := 0.0


func _ready() -> void:
	if OS.get_name() == "Web":
		var event = InputEventKey.new()
		event.physical_keycode = KEY_ESCAPE
		InputMap.action_erase_event("pause_game", event)

	survival_time = 0.0


func _process(delta: float) -> void:
	survival_time += delta


func _unhandled_input(event: InputEvent) -> void:
	if OS.is_debug_build():
		if event is InputEventKey and event.keycode == KEY_SHIFT:
			if event.pressed:
				Engine.time_scale = 5.0
			else:
				Engine.time_scale = 1.0
		elif event is InputEventKey and event.keycode == KEY_F12 and event.pressed:
			take_screenshot()


func take_screenshot() -> void:
	var date = Time.get_date_string_from_system().replace(".","_")
	var time :String = Time.get_time_string_from_system().replace(":","_")
	var screenshot_path = "user://" + "screenshot_" + date + "_" + time + ".png"
	var img = get_viewport().get_texture().get_image()
	img.save_png(screenshot_path)


func reset_stats() -> void:
	stats = {
		"survival_time": 0.0,
		"jumps": 0,
		"gold": 0,
		"death_reason": DeathReason.NONE,
	}

	survival_time = 0.0
