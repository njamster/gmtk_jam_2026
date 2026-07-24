extends TileMapLayer


var atlas_coords := [
	Vector2i(0, 1),  # 0
	Vector2i(1, 1),  # 1
	Vector2i(2, 1),  # 2
	Vector2i(3, 1),  # 3
	Vector2i(4, 1),  # 4
	Vector2i(0, 2),  # 5
	Vector2i(1, 2),  # 6
	Vector2i(2, 2),  # 7
	Vector2i(3, 2),  # 8
	Vector2i(4, 2),  # 9
]


func _ready() -> void:
	Global.tilemap = self

	randomize_counters()


func randomize_counters() -> void:
	for cell in get_used_cells():
		if get_cell_atlas_coords(cell) == Vector2i(0, 0):
			continue
		set_cell(cell, 1, atlas_coords[randi_range(1, 9)])
		#set_cell(0, cell, 1, atlas_coords[1 + randi() % 9])


func is_blocked(pos: Vector2) -> bool:
	var cell = local_to_map(pos)
	if get_cell_atlas_coords(cell) == Vector2i(0, 0) or \
	   get_cell_atlas_coords(cell) == Vector2i(0, 1):
			return true
	return false


func is_gap(pos: Vector2) -> bool:
	var cell = local_to_map(pos)
	if get_cell_atlas_coords(cell) == Vector2i(0, 1):
		return true
	return false


func count_down_position(pos: Vector2) -> void:
	var cell = local_to_map(pos)
	var tile_data = get_cell_atlas_coords(cell)
	match tile_data:
		Vector2i(4, 2):
			set_cell(cell, 1, Vector2i(3, 2))
		Vector2i(3, 2):
			set_cell(cell, 1, Vector2i(2, 2))
		Vector2i(2, 2):
			set_cell(cell, 1, Vector2i(1, 2))
		Vector2i(1, 2):
			set_cell(cell, 1, Vector2i(0, 2))
		Vector2i(0, 2):
			set_cell(cell, 1, Vector2i(4, 1))
		Vector2i(4, 1):
			set_cell(cell, 1, Vector2i(3, 1))
		Vector2i(3, 1):
			set_cell(cell, 1, Vector2i(2, 1))
		Vector2i(2, 1):
			set_cell(cell, 1, Vector2i(1, 1))
		Vector2i(1, 1):
			set_cell(cell, 1, Vector2i(0, 1))
			SoundManager.play_sound(preload("res://tilemap/sounds/crumble.wav"), true)
