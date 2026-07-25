extends CanvasLayer


func _ready() -> void:
	hide()  # by default

	Global.game_state_changed.connect(_on_game_state_changed)


func _on_game_state_changed(state: Global.GameState) -> void:
	if state == Global.GameState.GAME_OVER:
		show()

		for child in %Stats.get_children():
			child.queue_free()

		for i in Global.num_players:
			var player_stats := preload("res://autoloads/game_over_screen/player_stats.tscn").instantiate()
			player_stats.player_id = i
			player_stats.update()
			%Stats.add_child(player_stats)
	else:
		hide()


func _unhandled_input(event: InputEvent) -> void:
	if visible:
		if event is InputEventKey and event.keycode == KEY_R and event.pressed:
			get_tree().reload_current_scene()
