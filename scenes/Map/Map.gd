extends TileMap

# Basic Map
# -1=nocell, 0=Wall, 1=Floor

func is_blocked(cell):
	return get_cellv(cell)==1