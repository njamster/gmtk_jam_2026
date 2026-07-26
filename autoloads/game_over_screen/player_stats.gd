extends VBoxContainer


var flavour_texts := {
	Global.DeathReason.NONE: [
		"You survived!!!"
	],
	Global.DeathReason.FALL: [
		"You fell to your death!",
		"Well... You fell!",
		"Falling feels funny, isn't it?",
		"Wowsie! That was deep..."
	],
	Global.DeathReason.ENEMY: [
		"You got killed by an enemy!",
		"Must have been Ghostface Killah!"
	]
}


func update() -> void:
	$DeathReason.text = flavour_texts[Global.stats.death_reason][
		randi() % flavour_texts[Global.stats.death_reason].size()
	]

	if Global.stats.death_reason == Global.DeathReason.NONE and Global.stats.gold == 0:
		$DeathReason.text = "You survived – but left all that precious gold behind you!"

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
