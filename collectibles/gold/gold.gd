extends Area2D


func spawn() -> void:
	$Sprite.scale = Vector2.ZERO
	$Sprite.position.y = -100
	$Sprite.modulate.a = 0.0
	var tween := create_tween().set_parallel()
	tween.tween_property($Sprite, "scale", Vector2.ONE, 0.5).set_ease(Tween.EASE_IN)
	tween.tween_property($Sprite, "modulate:a", 1.0, 0.5).set_ease(Tween.EASE_OUT)
	tween.tween_property($Sprite, "position:y", +100, 0.5).as_relative()


func pickup() -> void:
	Global.stats.gold += 1
	AudioManager.play_sound(preload("res://player/sounds/gold.wav"), "Sounds", -10)
	queue_free()


func drop_down() -> void:
	AudioManager.play_sound(preload("sounds/fall.wav"), "Sounds", -10)

	var tween := create_tween()
	tween.tween_property($Sprite, "scale", Vector2.ZERO, 0.5)
	await tween.finished
	queue_free()
