extends TileMapLayer

const WALL_TILE := Vector2i(0, 0)

const STURDY_FLOOR := Vector2i(4, 0)

const GAP_TILE := Vector2i(0, 1)

const DURABILITY_1 := Vector2i(1, 1)
const DURABILITY_2 := Vector2i(2, 1)
const DURABILITY_3 := Vector2i(3, 1)
const DURABILITY_4 := Vector2i(4, 1)
const DURABILITY_5 := Vector2i(0, 2)
const DURABILITY_6 := Vector2i(1, 2)
const DURABILITY_7 := Vector2i(2, 2)
const DURABILITY_8 := Vector2i(3, 2)
const DURABILITY_9 := Vector2i(4, 2)

const MAX_DURABILITY := 5

const atlas_coords := [
	GAP_TILE,
	DURABILITY_1,
	DURABILITY_2,
	DURABILITY_3,
	DURABILITY_4,
	DURABILITY_5,
	DURABILITY_6,
	DURABILITY_7,
	DURABILITY_8,
	DURABILITY_9
]

const MIN_X := 1
const MAX_X := 39
const MIN_Y := 1
const MAX_Y := 22


func _ready() -> void:
	Global.tilemap = self
	Global.tile_size = tile_set.tile_size.x

	randomize_counters()

	await get_tree().create_timer(1.0).timeout
	earthquake()


func randomize_counters() -> void:
	for x in range(MIN_X, MAX_X):
		for y in range(MIN_Y, MAX_Y):
			var cell = Vector2i(x, y)
			if get_cell_atlas_coords(cell) == WALL_TILE or \
			   get_cell_atlas_coords(cell) == GAP_TILE or \
			   get_cell_atlas_coords(cell) == STURDY_FLOOR:
				continue
			set_cell(cell, 0, atlas_coords[randi_range(1, MAX_DURABILITY)])

			#if randi_range(1, 5) == 1:
				#var gold := preload("res://collectibles/gold.tscn").instantiate()
				#gold.global_position = map_to_local(cell)
				#add_child(gold)


func is_blocked(pos: Vector2) -> bool:
	var cell = local_to_map(pos)
	if get_cell_atlas_coords(cell) == WALL_TILE or \
	   get_cell_atlas_coords(cell) == GAP_TILE:
			return true
	return false


func is_gap(pos: Vector2) -> bool:
	var cell = local_to_map(pos)
	if get_cell_atlas_coords(cell) == GAP_TILE:
		return true
	return false


func count_down_position(pos: Vector2) -> void:
	count_down_cell(local_to_map(pos))


func count_down_cell(cell: Vector2i, play_sounds := true) -> void:
	var tile_data = get_cell_atlas_coords(cell)
	match tile_data:
		DURABILITY_9:
			set_cell(cell, 0, DURABILITY_8)
		DURABILITY_8:
			set_cell(cell, 0, DURABILITY_7)
		DURABILITY_7:
			set_cell(cell, 0, DURABILITY_6)
		DURABILITY_6:
			set_cell(cell, 0, DURABILITY_5)
		DURABILITY_5:
			set_cell(cell, 0, DURABILITY_4)
		DURABILITY_4:
			set_cell(cell, 0, DURABILITY_3)
		DURABILITY_3:
			set_cell(cell, 0, DURABILITY_2)
		DURABILITY_2:
			set_cell(cell, 0, DURABILITY_1)
		DURABILITY_1:
			set_cell(cell, 0, GAP_TILE)
			if play_sounds:
				SoundManager.play_sound(preload("res://tilemap/sounds/crumble.wav"))


func earthquake() -> void:
	for x in range(MIN_X, MAX_X):
		for y in range(MIN_Y, MAX_Y):
			var cell = Vector2i(x, y)
			if get_cell_atlas_coords(cell) == WALL_TILE or \
			   get_cell_atlas_coords(cell) == GAP_TILE or \
			   get_cell_atlas_coords(cell) == STURDY_FLOOR:
					continue
			count_down_cell(cell, false)

	SoundManager.play_sound(preload("res://tilemap/sounds/earthquake.wav"))
	Global.camera.screenshake(0.45)


func small_earthquake() -> void:
	SoundManager.play_sound(preload("res://tilemap/sounds/earthquake.wav"))

	var tiles := []
	for i in range(1, MAX_DURABILITY + 1):
		tiles.append([] + get_used_cells_by_id(0, atlas_coords[i]))

	const TILES_CHANGED_PER_LAYER := 10

	for i in range(TILES_CHANGED_PER_LAYER):
		var tiles_count_down := false
		for j in range(MAX_DURABILITY):
			if tiles[j].size():
				var random_tile_id = randi() % tiles[j].size()
				var cell = tiles[j].pop_at(random_tile_id)
				count_down_cell(cell)
				tiles_count_down = true
		if tiles_count_down:
			Global.camera.screenshake(0.08)
			await get_tree().create_timer(0.05).timeout
		else:
			break
