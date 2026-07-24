extends Control


var survival_time := 0.0


func _ready() -> void:
	SoundManager.play_music(preload("res://music/background_music.ogg"), false)

	for i in Global.num_players:
		var player := preload("res://player/player.tscn").instantiate()
		player.id = i + 1
		if player.id == 1:
			player.global_position = $TileMap.map_to_local(Vector2i(0, 16))
		else:
			player.global_position = $TileMap.map_to_local(Vector2i(0, 17))
		add_child(player)

	for i in Global.num_enemies:
		var enemy := preload("res://enemies/enemy.tscn").instantiate()
		enemy.global_position = $TileMap.map_to_local(Vector2i(randi_range(2, 57), randi_range(2, 31)))
		add_child(enemy)


func _process(delta: float) -> void:
	survival_time += delta
	$SurvivalTime.text = "%02d:%02d" % [survival_time / 60, fmod(survival_time, 60)]
	if Global.num_players >= 1:
		$JumpsP1.text = "Jumps: " + str(Global.stats[0].jumps)
	if Global.num_players >= 2:
		$JumpsP2.text = "Jumps: " + str(Global.stats[1].jumps)
