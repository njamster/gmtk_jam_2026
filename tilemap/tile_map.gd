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

const TILE_ROTATIONS = [
	0,
	TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_H,
	TileSetAtlasSource.TRANSFORM_FLIP_H | TileSetAtlasSource.TRANSFORM_FLIP_V,
	TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_V,
]

const MIN_X := 1
const MAX_X := 38
const MIN_Y := 1
const MAX_Y := 21


var free_cells := []
var gold_cells :=  {}

func _ready() -> void:
	Global.tilemap = self
	Global.tile_size = tile_set.tile_size.x

	randomize_counters()

	await get_tree().create_timer(1.0).timeout
	earthquake()

	await get_tree().create_timer(0.5).timeout
	spawn_gold(40)


func randomize_counters() -> void:
	for x in range(MIN_X, MAX_X + 1):
		for y in range(MIN_Y, MAX_Y +1 ):
			var cell = Vector2i(x, y)
			if get_cell_atlas_coords(cell) == WALL_TILE or \
			   get_cell_atlas_coords(cell) == GAP_TILE or \
			   get_cell_atlas_coords(cell) == STURDY_FLOOR:
				continue
			set_cell(cell, 0, atlas_coords[randi_range(1, MAX_DURABILITY)], TILE_ROTATIONS[randi_range(0, 3)])
			free_cells.append(cell)


func spawn_gold(amount: int) -> void:
	if amount <= 1:
		push_warning("Cannot spawn negative amounts of gold!")
		return  # early

	if free_cells.size():
		for i in range(amount):
			var cell = free_cells.pop_at(randi() % free_cells.size())
			var gold := preload("res://collectibles/gold/gold.tscn").instantiate()
			gold.global_position = map_to_local(cell)
			add_child(gold)
			gold.spawn()

			gold_cells[cell] = gold
			await get_tree().create_timer(0.02).timeout


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
			set_cell(cell, 0, DURABILITY_8, get_cell_alternative_tile(cell))
		DURABILITY_8:
			set_cell(cell, 0, DURABILITY_7, get_cell_alternative_tile(cell))
		DURABILITY_7:
			set_cell(cell, 0, DURABILITY_6, get_cell_alternative_tile(cell))
		DURABILITY_6:
			set_cell(cell, 0, DURABILITY_5, get_cell_alternative_tile(cell))
		DURABILITY_5:
			set_cell(cell, 0, DURABILITY_4, get_cell_alternative_tile(cell))
		DURABILITY_4:
			set_cell(cell, 0, DURABILITY_3, get_cell_alternative_tile(cell))
		DURABILITY_3:
			set_cell(cell, 0, DURABILITY_2, get_cell_alternative_tile(cell))
		DURABILITY_2:
			set_cell(cell, 0, DURABILITY_1, get_cell_alternative_tile(cell))
		DURABILITY_1:
			set_cell(cell, 0, GAP_TILE, get_cell_alternative_tile(cell))
			free_cells.erase(cell)
			if cell in gold_cells:
				if is_instance_valid(gold_cells[cell]):
					gold_cells[cell].drop_down()
				gold_cells.erase(cell)
			if play_sounds:
				AudioManager.play_sound(preload("res://tilemap/sounds/crumble.wav"))


func earthquake() -> void:
	for x in range(MIN_X, MAX_X + 1):
		for y in range(MIN_Y, MAX_Y + 1):
			var cell = Vector2i(x, y)
			if get_cell_atlas_coords(cell) == WALL_TILE or \
			   get_cell_atlas_coords(cell) == GAP_TILE or \
			   get_cell_atlas_coords(cell) == STURDY_FLOOR or \
			   _is_near_player(cell):
					continue
			count_down_cell(cell, false)

	AudioManager.play_sound(preload("res://tilemap/sounds/earthquake.wav"))
	Global.camera.screenshake(0.45)


func small_earthquake() -> void:
	AudioManager.play_sound(preload("res://tilemap/sounds/earthquake.wav"))

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
				if _is_near_player(cell):
					continue
				count_down_cell(cell)
				tiles_count_down = true
		if tiles_count_down:
			Global.camera.screenshake(0.08)
			await get_tree().create_timer(0.05).timeout
		else:
			break

	spawn_gold(6)


func _is_near_player(cell: Vector2i) -> bool:
	if is_instance_valid(Global.player):
		var player_cell := local_to_map(Global.player.global_position)
		if abs(player_cell.x - cell.x) <= 2 and abs(player_cell.y - cell.y) <= 2:
			return true

	return false
