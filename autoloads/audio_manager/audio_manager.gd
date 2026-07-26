extends Node

const MAX_SIMULTANEOUS_SOUNDS := 15

const CROSSFADE_TIME := 1.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func play_music(stream: AudioStream, crossfade := true, loop := true) -> void:
	var old_track_playing := $Music.get_child_count() > 0

	if old_track_playing:
		var old_track := $Music.get_child(-1)

		if old_track.stream == stream:
			return  # early

		if crossfade:
			var tween := get_tree().create_tween()
			tween.tween_property(old_track, "volume_db", -80, CROSSFADE_TIME).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
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

	if old_track_playing and crossfade:
		new_track.volume_db = -80
		var tween := get_tree().create_tween()
		tween.tween_property(new_track, "volume_db", 0, CROSSFADE_TIME).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)


func play_sound(stream: AudioStream, bus_name := "Sounds", volume_change := 0, min_pitch := 1.0, max_pitch := 1.0) -> void:
	if $Sounds.get_child_count() < MAX_SIMULTANEOUS_SOUNDS:
		var player := AudioStreamPlayer.new()
		player.stream = stream
		player.bus = bus_name
		player.volume_db = volume_change
		player.pitch_scale = randf_range(min_pitch, max_pitch)
		$Sounds.add_child(player)
		player.play()

		player.finished.connect(player.queue_free)
	else:
		push_warning("Sound limit reached!")
