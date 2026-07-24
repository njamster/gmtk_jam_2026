extends Control


func _ready() -> void:
	for i in AudioServer.bus_count:
		var setting := preload("res://settings/audio_setting.tscn").instantiate()
		setting.bus_name = AudioServer.get_bus_name(i)
		%AudioSettings.add_child(setting)

	%Back.pressed.connect(_back)

	%Back.grab_focus()


func _back() -> void:
	_store_settings()
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _store_settings() -> void:
	var settings_file = ConfigFile.new()
	for setting in %AudioSettings.get_children():
		settings_file.set_value("Audio", setting.bus_name, setting.volume)
	settings_file.save("user://settings.cfg")
