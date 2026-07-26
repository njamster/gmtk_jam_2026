extends Node

const PATH := "user://settings.cfg"

class _Audio:
	var master := RangedSetting.new(
		80,		# default_value
		0,		# min_value
		100,	# max_value
		func(value):
			AudioServer.set_bus_volume_linear(
				AudioServer.get_bus_index("Master"),
				value / 100.0
			)
	)
	var music := RangedSetting.new(
		80,		# default_value
		0,		# min_value
		100,	# max_value
		func(value):
			AudioServer.set_bus_volume_linear(
				AudioServer.get_bus_index("Music"),
				value / 100.0
			)
	)
	var sfx := RangedSetting.new(
		80,		# default_value
		0,		# min_value
		100,	# max_value
		func(value):
			AudioServer.set_bus_volume_linear(
				AudioServer.get_bus_index("SFX"),
				value / 100.0
			)
	)
	var ui := RangedSetting.new(
		80,		# default_value
		0,		# min_value
		100,	# max_value
		func(value):
			AudioServer.set_bus_volume_linear(
				AudioServer.get_bus_index("UI"),
				value / 100.0
			)
	)
var audio := _Audio.new()

class _Accessibility:
	var screenshake_intensity := RangedSetting.new(
		100,	# default_value
		0,		# min_value
		100		# max_value
	)
var accessibility := _Accessibility.new()


func _ready() -> void:
	_load_settings(OS.is_debug_build())


func _load_settings(print_settings := false) -> void:
	var settings_file := ConfigFile.new()
	var error := settings_file.load(PATH)

	if error == OK:
		for section in settings_file.get_sections():
			if not section in self:
				push_warning("Unknown section '%s'!" % section)
				continue  # with next section

			for key in settings_file.get_section_keys(section):
				if key in self:
					push_warning("Unknown key '%s'!" % key)
					continue  # with next key

				get(section)[key].value = clamp(
						settings_file.get_value(section, key),
						get(section)[key].min_value,
						get(section)[key].max_value
					)

	if print_settings:
		_print_settings()


func _print_settings() -> void:
	print_rich("║ [b]SETTINGS[/b]")
	for category_name in _get_script_variables(self):
		print("║")
		var category = get(category_name)
		print_rich("║ [b]%s[/b]:" % category_name.capitalize())
		for setting_name in _get_script_variables(category):
			var setting = category.get(setting_name)
			if setting is RangedSetting:
				print("║ • %s: %d" % [setting_name.capitalize(), setting.value])


func _exit_tree() -> void:
	_save_settings()


func _save_settings() -> void:
	var settings_file := ConfigFile.new()

	for category_name in _get_script_variables(self):
		var category = get(category_name)
		for setting_name in _get_script_variables(category):
			var setting = category.get(setting_name)
			if setting is RangedSetting:
				settings_file.set_value(
					category_name,
					setting_name,
					setting.value
				)

	settings_file.save(PATH)


func _get_script_variables(base):
	var category_names := []

	for property in base.get_property_list():
		if property.usage == PROPERTY_USAGE_SCRIPT_VARIABLE:
			category_names.append(property.name)

	return category_names
