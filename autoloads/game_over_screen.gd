extends CanvasLayer


func _ready() -> void:
	hide()  # by default

	for i in Global.num_players:
		var player_stats := preload("res://autoloads/game_over_screen/player_stats.tscn").instantiate()
		player_stats.player_id = i
		%Stats.add_child(player_stats)

	Global.game_state_changed.connect(_on_game_state_changed)


func _on_game_state_changed(state: Global.GameState) -> void:
	if state == Global.GameState.GAME_OVER:
		show()
	else:
		hide()
