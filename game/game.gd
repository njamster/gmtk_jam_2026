extends Control


func _ready() -> void:
	Global.reset_stats()

	Global.game_state = Global.GameState.RUNNING

	AudioManager.play_music(preload("res://music/game_music.ogg"))

	for i in Settings.accessibility.num_enemies.value:
		var enemy := preload("res://enemies/enemy.tscn").instantiate()
		enemy.global_position = $TileMap.map_to_local(
			Vector2i(
				randi_range(3, $TileMap.MAX_X),
				randi_range(3, $TileMap.MAX_Y)
			)
		)
		add_child(enemy)

	$QuakeTimer.timeout.connect($TileMap.small_earthquake)


func _unhandled_input(event: InputEvent) -> void:
	if Global.game_state == Global.GameState.RUNNING:
		if event.is_action_pressed("quick_restart"):
			get_tree().reload_current_scene()
		elif event.is_action_pressed("pause_game"):
			Global.game_state = Global.GameState.PAUSED
