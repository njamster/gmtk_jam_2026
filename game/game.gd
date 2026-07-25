extends Control


func _ready() -> void:
	Global.num_alive_players = Global.num_players

	Global.game_state = Global.GameState.RUNNING

	SoundManager.play_music(preload("res://music/background_music.ogg"), true, false)

	for i in Global.num_players:
		var player := preload("res://player/player.tscn").instantiate()
		if Global.num_players > 1:
			player.id = i + 1
		if player.id == 1:
			player.global_position = $TileMap.map_to_local(Vector2i(0, 10)) + $TileMap.position
		else:
			player.global_position = $TileMap.map_to_local(Vector2i(0, 11)) + $TileMap.position
		add_child(player)

	for i in Global.num_enemies:
		var enemy := preload("res://enemies/enemy.tscn").instantiate()
		enemy.global_position = $TileMap.map_to_local(
			Vector2i(
				randi_range(3, $TileMap.MAX_X),
				randi_range(3, $TileMap.MAX_Y))
		)
		add_child(enemy)

	$QuakeTimer.timeout.connect($TileMap.small_earthquake)


func _unhandled_input(event: InputEvent) -> void:
	if Global.game_state == Global.GameState.RUNNING:
		if event.is_action_pressed("quick_restart"):
			get_tree().reload_current_scene()
		elif event.is_action_pressed("pause_game"):
			Global.game_state = Global.GameState.PAUSED
