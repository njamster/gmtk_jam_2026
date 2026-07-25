extends HBoxContainer

@export var bus_name: String

const STEP_SIZE := 0.1


var volume: float:
	set(value):
		volume = value
		$Value.text = str(roundi(value * 100)) + "%"


func _ready() -> void:
	$Label.text = bus_name
	volume = AudioServer.get_bus_volume_linear(
		AudioServer.get_bus_index(bus_name)
	)

	_check_limits()

	%Decrease.pressed.connect(_change_volume.bind(+STEP_SIZE))
	%Increase.pressed.connect(_change_volume.bind(-STEP_SIZE))


func _check_limits() -> void:
	%Decrease.disabled = (volume == 0.0)
	%Increase.disabled = (volume == 1.0)


func _change_volume(offset: float) -> void:
	volume = clampf(volume - offset, 0.0, 1.0)
	AudioServer.set_bus_volume_linear(
		AudioServer.get_bus_index(bus_name),
		volume
	)
	_check_limits()
