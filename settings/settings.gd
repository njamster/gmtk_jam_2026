extends Control


func _ready() -> void:
	%Master.map_to("Audio")
	%Music.map_to("Audio")
	%SFX.map_to("Audio")
	%UI.map_to("Audio")

	%Screenshake.map_to("Accessibility")

	%Back.pressed.connect(_back)

	%Back.grab_focus()


func _back() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
