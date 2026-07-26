extends VBoxContainer


func update() -> void:
	if Global.stats.death_reason:
		$DeathReason.text = Global.stats.death_reason
	else:
		$DeathReason.text = "You survived!"

	%Gold/Value.text = str(Global.stats.gold)

	%SurvivalTime/Value.text = "%02d:%02d" % [
		Global.stats.survival_time / 60,
		fmod(Global.stats.survival_time, 60)
	]

	%NumJumps/Value.text = str(Global.stats.jumps)

	if Global.stats.death_reason:
		%SurvivedState/Value.text = "No"
	else:
		%SurvivedState/Value.text = "Yes"
