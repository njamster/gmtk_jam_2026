extends Node

const MAX_SIMULTANEOUS_SOUNDS := 10


func play_music(stream: AudioStream, loop := true, fade_over := true) -> void:
	var old_track_playing := $Music.get_child_count() > 0

	if old_track_playing:
		var old_track := $Music.get_child(0)
		if fade_over:
			var tween := get_tree().create_tween()
			tween.tween_property(old_track, "volume_db", -80, 2.0)
			tween.finished.connect(old_track.queue_free)
		else:
			old_track.queue_free()

	var new_track := AudioStreamPlayer.new()
	new_track.stream = stream
	new_track.bus = "Music"
	if loop:
		new_track.finished.connect(new_track.play)
	$Music.add_child(new_track)
	new_track.play()

	if old_track_playing and fade_over:
		new_track.volume_db = -80
		var tween := get_tree().create_tween()
		tween.tween_property(new_track, "volume_db", 0, 2.0)


func play_sound(stream: AudioStream, randomize_pitch := false) -> void:
	if $Sounds.get_child_count() < MAX_SIMULTANEOUS_SOUNDS:
		var player := AudioStreamPlayer.new()
		player.stream = stream
		player.bus = "Sounds"
		$Sounds.add_child(player)
		player.play()

		if randomize_pitch:
			player.pitch_scale = randf_range(0.8, 1.2)

		player.finished.connect(player.queue_free)
	else:
		print("Sound limit reached!")
