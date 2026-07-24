extends CanvasLayer


func _ready() -> void:
	hide()  # by default

	Global.game_state_changed.connect(_on_game_state_changed)


func _on_game_state_changed(state: Global.GameState) -> void:
	if state == Global.GameState.GAME_OVER:
		show()
	else:
		hide()
