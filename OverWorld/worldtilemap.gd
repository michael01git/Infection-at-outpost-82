extends TileMapLayer

var astar = AStarGrid2D.new()
var map_rect: Rect2i
var tile_size = Vector2(16,16)

func _ready():
	setup_grid()


func setup_grid():
	var tilemap_size: Vector2i = get_used_rect().end - get_used_rect().position
	map_rect = Rect2i(Vector2i.ZERO, tilemap_size)
	
	astar.region = map_rect
	astar.cell_size = tile_size
	
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	
	astar.update()
	
	for i in tilemap_size.x:
		for j in tilemap_size.y:
			var coords = Vector2(i, j)
			var tile_data = get_cell_tile_data(coords)
			if tile_data and tile_data.get_custom_data("type") == "wall":
				astar.set_point_solid(coords)
	
	pass

func is_point_walkable(pos):
	var map_pos = local_to_map(pos)
	if map_rect.has_point(map_pos):
		return true
	else:
		return false
