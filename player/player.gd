extends Area2D

var id: int

var inputs = {
	"move_up": Vector2.UP,
	"move_right": Vector2.RIGHT,
	"move_down": Vector2.DOWN,
	"move_left": Vector2.LEFT
}

var direction := Vector2.RIGHT
var move_speed := 0.3 # seconds per tile

var is_moving := false
var is_dead := false


func _ready():
	match id:
		1:
			$Sprite.modulate = Color.BLUE
		2:
			$Sprite.modulate = Color.WEB_GREEN

	body_entered.connect(func(_body):
		if not is_dead:
			var tween := create_tween()
			tween.tween_property($Sprite, "scale", 2.0 * Vector2.ONE, 0.4)
			tween.tween_property($Sprite, "scale", Vector2.ZERO, 0.2)
			die("You got killed by an enemy!")
	)

	if Global.auto_move:
		move()


func _unhandled_input(event):
	for dir in inputs.keys():
		var action = dir
		if id:
			action = "%s_p%d" % [dir, id]
		if event.is_action_pressed(action):
			direction = inputs[dir]
			if not Global.auto_move and not is_dead and not is_moving:
				move()


func move():
	is_moving = true

	var tween = create_tween()
	var previous_position := position

	if not Global.tilemap.is_blocked(position + direction * Global.tile_size):
		# next tile is free
		tween.tween_property(self, "position", direction * Global.tile_size, move_speed).as_relative()
	elif Global.tilemap.is_gap(position + direction * Global.tile_size):
		# next tile is a gap...
		if not Global.tilemap.is_blocked(position + 2 * direction * Global.tile_size):
			# ... and can be jumped over
			tween.tween_property(self, "position", 2 * direction * Global.tile_size, 2 * move_speed).as_relative()
			tween.parallel().tween_property($Sprite, "scale", 2.0 * Vector2.ONE, move_speed)
			tween.parallel().tween_property($Sprite, "scale", Vector2.ONE, move_speed).set_delay(move_speed)
			SoundManager.play_sound(preload("res://player/sounds/jump.wav"))
			Global.stats[id-1].jumps += 1
		else:
			# ... and you ran right into it
			tween.tween_property(self, "position", direction * Global.tile_size, move_speed).as_relative()
			tween.tween_property(self, "scale", Vector2.ZERO, move_speed)
			die("You fell to your death!")
	else:
		# next tile is a wall
		direction = -1 * direction
		tween.tween_property(self, "position", direction * Global.tile_size, move_speed).as_relative()
		if Global.auto_move and not is_dead:
			move()
		is_moving = false
		return  # early

	await tween.finished

	if is_dead and Global.num_alive_players == 0:
		Global.game_state_changed.emit(Global.GameState.GAME_OVER)

	if Global.decay_enabled:
		Global.tilemap.count_down_position(previous_position)

	if Global.auto_move and not is_dead:
		move()

	is_moving = false


func die(reason: String):
	is_dead = true
	Global.num_alive_players -= 1
	Global.stats[id-1].death_reason = reason
	Global.stats[id-1].survival_time = Global.survival_time
	SoundManager.play_sound(preload("res://player/sounds/hurt.wav"))
