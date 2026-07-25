@tool
extends BoxContainer


@export var label := "":
	set(new_value):
		label = new_value
		$Label.text = str(new_value)


@export var key := "":
	set(new_value):
		key = new_value


@export var is_percentage := true:
	set(new_value):
		is_percentage = new_value
		_update_displayed_value()
		_update_width()


@export var value := 80:
	set(new_value):
		value = new_value
		if _mapped_to:
			_mapped_to.value = new_value
		_update_displayed_value()


@export var min_value := 0:
	set(new_value):
		min_value = min(new_value, max_value)
		_update_displayed_value()


@export var max_value := 100:
	set(new_value):
		max_value = max(new_value, min_value)
		_update_displayed_value()
		_update_width()

@export_range(0, Global.MAX_INT, 1) var step_size := 10:
	set(new_value):
		step_size = new_value

var _mapped_to: RangedSetting


func _ready() -> void:
	%Decrease.pressed.connect(_change_value.bind(+1))
	%Increase.pressed.connect(_change_value.bind(-1))

	_update_displayed_value()
	_update_width()
	_check_limits()


func map_to(category: String) -> void:
	category = Utils.to_snake_case(category)

	if not category in Settings:
		push_error("Cannot map to non-existent category '%s'" % category)
		return  # early

	if not key:
		key = Utils.to_snake_case(label)

	if not key in Settings[category]:
		push_error("Cannot map to non-existent setting '%s'" % key)
		return  # early

	_mapped_to = Settings[category][key]

	value = _mapped_to.value
	min_value = _mapped_to.min_value
	max_value = _mapped_to.max_value


func _check_limits() -> void:
	%Decrease.disabled = (value == min_value)
	%Increase.disabled = (value == max_value)


func _change_value(direction: float) -> void:
	value = clamp(value - direction * step_size, min_value, max_value)
	_check_limits()


func _update_displayed_value() -> void:
	var displaye_value = clamp(value, min_value, max_value)
	if is_percentage:
		%Value.text = str(displaye_value) + "%"
	else:
		%Value.text = str(displaye_value)


func _update_width(scaling_factor := 1.3) -> void:
	var reference_string := str(max_value)
	if is_percentage:
		reference_string += "%"

	%Value.custom_minimum_size.x = scaling_factor * %Value.get_theme_font("font").get_string_size(
		reference_string,
		%Value.horizontal_alignment,
		-1,
		%Value.get_theme_font_size("font_size")
	).x
