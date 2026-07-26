extends Area2D


var inputs = {
	"move_up": Vector2.UP,
	"move_right": Vector2.RIGHT,
	"move_down": Vector2.DOWN,
	"move_left": Vector2.LEFT
}

var move_direction := Vector2.RIGHT
var move_speed := 0.3  # seconds per tile


func _ready():
	Global.player = self

	body_entered.connect(
		func(_body):
			# It's an enemy
			var tween := create_tween()
			tween.tween_property($Sprite, "scale", 2.0 * Vector2.ONE, 0.4)
			tween.tween_property($Sprite, "scale", Vector2.ZERO, 0.2)
			die(Global.DeathReason.ENEMY)
	)

	area_entered.connect(
		func(area):
			if area.has_method("pickup"):
				# It's a collectible
				area.pickup()
			else:
				# It's the exit area
				Global.stats.survival_time = Global.survival_time
				Global.game_state = Global.GameState.GAME_OVER
	)

	auto_move()


func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move_direction = inputs[dir]


func auto_move():
	var one_tile_ahead = position + move_direction * Global.tile_size
	var two_tiles_ahead = position + 2 * move_direction * Global.tile_size

	if not Global.tilemap.is_blocked(one_tile_ahead):
		# next tile is free
		await run()
	elif Global.tilemap.is_gap(one_tile_ahead):
		# next tile is a gap...
		if not Global.tilemap.is_blocked(two_tiles_ahead):
			await jump()  # ... and can be jumped over
		elif Global.tilemap.is_gap(two_tiles_ahead):
			await jump(false)  # ... and cannot be jumped over
		else:
			await run(false)
	else:
		# next tile is a wall
		move_direction = -1 * move_direction
		await run()

	auto_move()


func run(success := true) -> void:
	var previous_position := position

	var tween = create_tween().set_parallel()
	tween.tween_property(self, "position", move_direction * Global.tile_size, move_speed).as_relative()
	if Global.decay_enabled:
		tween.tween_callback(
			Global.tilemap.count_down_position.bind(previous_position)
		).set_delay(0.75 * move_speed)
	if not success:
		tween.tween_property($Sprite, "scale", Vector2.ZERO, 0.75 * move_speed).set_delay(0.75 * move_speed)
		tween.tween_callback(
			AudioManager.play_sound.bind(preload("res://player/sounds/wilhelm_scream.ogg"))
		).set_delay(0.5 * move_speed)
	await tween.finished

	if not success:
		die(Global.DeathReason.FALL)


func jump(success := true) -> void:
	var previous_position := position

	AudioManager.play_sound(preload("res://player/sounds/jump.wav"))

	var tween = create_tween().set_parallel()
	tween.tween_property(self, "position", 2 * move_direction * Global.tile_size, 1.5 * move_speed).as_relative()
	if Global.decay_enabled:
		tween.tween_callback(
			Global.tilemap.count_down_position.bind(previous_position)
		).set_delay(0.5 * move_speed)
	tween.tween_property($Sprite, "scale", 2.0 * Vector2.ONE, 0.75 * move_speed)
	if success:
		tween.tween_property($Sprite, "scale", Vector2.ONE, 0.75 * move_speed).set_delay(0.75 * move_speed)
	else:
		tween.tween_property($Sprite, "scale", Vector2.ZERO, 1.25 * move_speed).set_delay(1.25 * move_speed)
		tween.tween_callback(
			AudioManager.play_sound.bind(preload("res://player/sounds/wilhelm_scream.ogg"))
		).set_delay(1.0 * move_speed)
	await tween.finished

	if success:
		Global.stats.jumps += 1
	else:
		die(Global.DeathReason.FALL)


func die(reason: Global.DeathReason) -> void:
	Global.stats.death_reason = reason
	AudioManager.play_sound(preload("res://player/sounds/hurt.wav"))
	Global.stats.survival_time = Global.survival_time
	Global.game_state = Global.GameState.GAME_OVER
	queue_free()
