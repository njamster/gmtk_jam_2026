class_name BetterButton
extends Button


func _ready() -> void:
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

	mouse_entered.connect(_play_focus_sound)

	pressed.connect(_play_select_sound)


func _gui_input(event: InputEvent) -> void:
	if has_focus():
		if (
			event.is_action_pressed("ui_up") or \
			event.is_action_pressed("ui_right") or \
			event.is_action_pressed("ui_down") or \
			event.is_action_pressed("ui_left") or \
			event.is_action_pressed("ui_focus_next") or \
			event.is_action_pressed("ui_focus_prev")
		):
			var viewport := get_viewport()
			await get_tree().process_frame
			if viewport.gui_get_focus_owner() != self:
					_play_focus_sound()


func _play_focus_sound() -> void:
	AudioManager.play_sound(preload("sounds/focus.wav"), "UI", -10)


func _play_select_sound() -> void:
	AudioManager.play_sound(preload("sounds/select.wav"), "UI", -10)
