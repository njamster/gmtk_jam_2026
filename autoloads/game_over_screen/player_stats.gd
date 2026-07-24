extends VBoxContainer


var player_id := -1


func _ready() -> void:
	$Player.text = "Player %d" % [player_id + 1]

	visibility_changed.connect(func():
		if visible:
			_update_stats()
	)


func _update_stats() -> void:
	if Global.stats[player_id].death_reason:
		$DeathReason.text = Global.stats[player_id].death_reason

	%SurvivalTime/Value.text = "%02d:%02d" % [
		Global.stats[player_id].survival_time / 60,
		fmod(Global.stats[player_id].survival_time, 60)
	]

	%NumJumps/Value.text = str(Global.stats[player_id].jumps)

	if Global.stats[player_id].death_reason:
		%SurvivedState/Value.text = "No"
	else:
		%SurvivedState/Value.text = "Yes"
