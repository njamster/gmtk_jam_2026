extends Control


func _ready() -> void:
	Global.game_state_changed.emit(Global.GameState.RUNNING)

	SoundManager.play_music(preload("res://music/background_music.ogg"), true, false)

	for i in Global.num_players:
		var player := preload("res://player/player.tscn").instantiate()
		if Global.num_players > 1:
			player.id = i + 1
		if player.id == 1:
			player.global_position = $TileMap.map_to_local(Vector2i(0, 16))
		else:
			player.global_position = $TileMap.map_to_local(Vector2i(0, 17))
		add_child(player)

	for i in Global.num_enemies:
		var enemy := preload("res://enemies/enemy.tscn").instantiate()
		enemy.global_position = $TileMap.map_to_local(Vector2i(randi_range(3, 56), randi_range(3, 31)))
		add_child(enemy)
