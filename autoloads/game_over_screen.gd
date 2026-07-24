extends CanvasLayer


func _ready() -> void:
	hide()  # by default

	Global.game_state_changed.connect(_on_game_state_changed)


func _on_game_state_changed(state: Global.GameState) -> void:
	if state == Global.GameState.GAME_OVER:
		_update_stats()
		show()
	else:
		hide()


func _update_stats() -> void:
	%SurvivalTime.text = "%02d:%02d" % [
		Global.stats[0].survival_time / 60,
		fmod(Global.stats[0].survival_time, 60)
	]
	%NumJumps.text = str(Global.stats[0].jumps)
	if Global.stats[0].death_reason:
		%FlavorText.text = Global.stats[0].death_reason
		%SurvivedState.text = "No"
	else:
		%SurvivedState.text = "Yes"
