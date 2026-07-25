class_name RangedSetting
extends Object

var value: int:
	set(new_value):
		value = new_value
		if _callback:
			_callback.call(value)

var min_value: int
var max_value: int

var _callback: Callable


func _init(_value: int, _min_value: int, _max_value: int, callback = null) -> void:
	value = _value
	min_value = _min_value
	max_value = _max_value
	if callback:
		_callback = callback
