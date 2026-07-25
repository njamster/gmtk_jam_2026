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

	visibility_changed.connect(_on_visibility_changed)


func _on_visibility_changed() -> void:
	if visible:
		%Buttons.get_child(0).grab_focus()
		get_tree().paused = true
	else:
		get_tree().paused = false


func _resume() -> void:
	hide()


func _restart() -> void:
	get_tree().reload_current_scene()
	hide()


func _quit_to_menu():
	get_tree().change_scene_to_file("res://main_menu.tscn")
	hide()


func _quit_game() -> void:
	get_tree().quit()
	hide()
