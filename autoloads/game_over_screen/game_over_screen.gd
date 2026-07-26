extends CanvasLayer


func _ready() -> void:
	hide()  # by default

	Global.game_state_changed.connect(_on_game_state_changed)


func _on_game_state_changed(state: Global.GameState) -> void:
	if state == Global.GameState.GAME_OVER:
		AudioManager.play_music(preload("res://music/game_over_music.ogg"))
		%PlayerStats.update()
		show()
	else:
		hide()


func _unhandled_input(event: InputEvent) -> void:
	if visible:
		if event is InputEventKey and event.keycode == KEY_R and event.pressed:
			get_tree().reload_current_scene()
