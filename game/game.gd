extends Control


func _ready() -> void:
	Global.num_alive_players = Global.num_players

	Global.game_state_changed.emit(Global.GameState.RUNNING)

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


func _process(delta: float) -> void:
	$ProgressBar.value -= 15 * delta
	if $ProgressBar.value == 0:
		$TileMap.small_earthquake()
		$ProgressBar.value = 100


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("paused"):
		if not PauseMenu.visible:
			PauseMenu.show()
