extends Area2D


func pickup() -> void:
	Global.stats.gold += 1
	AudioManager.play_sound(preload("res://player/sounds/gold.wav"), "Sounds", -10)
	queue_free()
