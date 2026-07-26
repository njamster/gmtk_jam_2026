extends CanvasLayer


func _ready() -> void:
	hide()  # by default

	process_mode = Node.PROCESS_MODE_ALWAYS

	%Buttons/Resume.pressed.connect(_resume)
	%Buttons/Restart.pressed.connect(_restart)
	%Buttons/QuitToMenu.pressed.connect(_quit_to_menu)

	if OS.get_name() == "web":
		%Buttons/QuitGame.queue_free()
	else:
		%Buttons/QuitGame.pressed.connect(_quit_game)

	# make button focus wrap around at the ends of the button list
	if %Buttons is VBoxContainer:
		%Buttons.get_child(0).focus_neighbor_top = %Buttons.get_child(-1).get_path()
		%Buttons.get_child(-1).focus_neighbor_bottom = %Buttons.get_child(0).get_path()
	elif %Buttons is HBoxContainer:
		%Buttons.get_child(0).focus_neighbor_left = %Buttons.get_child(-1).get_path()
		%Buttons.get_child(-1).focus_neighbor_right = %Buttons.get_child(0).get_path()

	Global.game_state_changed.connect(_on_game_state_changed)


func _on_game_state_changed(state: Global.GameState) -> void:
	if state == Global.GameState.PAUSED:
		show()
		%Buttons.get_child(0).grab_focus()
		get_tree().paused = true
	else:
		hide()
		get_tree().paused = false


func _resume() -> void:
	Global.game_state = Global.GameState.RUNNING


func _restart() -> void:
	get_tree().reload_current_scene()
	Global.game_state = Global.GameState.RUNNING


func _quit_to_menu():
	get_tree().change_scene_to_file("res://main_menu.tscn")
	Global.game_state = Global.GameState.MAIN_MENU


func _quit_game() -> void:
	await get_tree().create_timer(0.3).timeout
	get_tree().quit()
