extends Control


func _ready() -> void:
	_read_in_credits_file()

	%Back.pressed.connect(_back)

	%Back.grab_focus()


func _read_in_credits_file() -> void:
	var file = FileAccess.open("res://credits/credits.md", FileAccess.READ)

	while not file.eof_reached():
		var line := file.get_line()

		if not line:
			continue  # Skip empty lines

		var label := Label.new()

		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.add_theme_color_override("font_color", Color.GOLD)
		label.add_theme_font_override("font", preload("res://fonts/caesar_dressing/CaesarDressing-Regular.ttf"))
		if line.begins_with("# "):
			%Credits.add_child(VBoxContainer.new())

			label.add_theme_font_size_override("font_size", 48)
			label.text = line.lstrip("# ")
		else:
			label.add_theme_font_size_override("font_size", 24)
			label.text = line

		if %Credits.get_child_count() and %Credits.get_child(-1) is VBoxContainer:
			%Credits.get_child(-1).add_child(label)
		else:
			%Credits.add_child(label)


func _back() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
