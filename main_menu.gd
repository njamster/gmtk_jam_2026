extends Control


func _ready() -> void:
	Global.game_state = Global.GameState.MAIN_MENU

	$OuterMargin/Title.text = ProjectSettings.get_setting("application/config/name")

	%Buttons/Singleplayer.pressed.connect(_singleplayer)
	%Buttons/Multiplayer.pressed.connect(_multiplayer)
	%Buttons/Settings.pressed.connect(_settings)
	%Buttons/Credits.pressed.connect(_credits)

	if OS.get_name() == "web":
		%Buttons/QuitGame.queue_free()
	else:
		%Buttons/QuitGame.pressed.connect(_quit)

	# make button focus wrap around at the ends of the button list
	if %Buttons is VBoxContainer:
		%Buttons.get_child(0).focus_neighbor_top = %Buttons.get_child(-1).get_path()
		%Buttons.get_child(-1).focus_neighbor_bottom = %Buttons.get_child(0).get_path()
	elif %Buttons is HBoxContainer:
		%Buttons.get_child(0).focus_neighbor_left = %Buttons.get_child(-1).get_path()
		%Buttons.get_child(-1).focus_neighbor_right = %Buttons.get_child(0).get_path()

	%Buttons.get_child(0).grab_focus()


func _singleplayer() -> void:
	Global.num_players = 1
	get_tree().change_scene_to_file("res://game/game.tscn")


func _multiplayer() -> void:
	Global.num_players = 2
	get_tree().change_scene_to_file("res://game/game.tscn")


func _settings() -> void:
	get_tree().change_scene_to_file("res://settings/settings.tscn")


func _credits() -> void:
	get_tree().change_scene_to_file("res://credits/credits.tscn")


func _quit() -> void:
	get_tree().quit()
