extends Node

var map = AStar.new()
var BOUNDS
var floor_cells = []

# dirty cells made by blocking Objects
# {Vector2 cell: bool not_blocked}
var dirty_cells = {}

func find_path(from, to):
	clean_dirty_cells()
	from = xy_to_id(from)
	to = xy_to_id(to)
	var path = map.get_point_path(from, to)
	if path.size() > 0:
		var v2path = PoolVector2Array()
		for point in path:
			v2path.append(Vector2(point.x,point.y))
		return v2path

func xy_to_id(cell):
	return cell.x + cell.y + (BOUNDS.x * cell.y)

func id_to_xy(id):
	var y = int(id / BOUNDS.x)
	var x = int(id) % int(BOUNDS.x)
	return Vector2(x-y,y)

func clean_dirty_cells():
	var cells = dirty_cells.keys()
	while !cells.empty():
		var cell = cells[0]
		var id = xy_to_id(cell)
		var is_point = dirty_cells[cell]
		# Scan neighbors
		for nx in range(-1,2):
			for ny in range(-1,2):
				var nid = xy_to_id(Vector2(cell.x+nx, cell.y+ny))
				if id != nid and id in floor_cells and nid in floor_cells:
					# Connect broken connections to neighbors
					if is_point:
						if !map.are_points_connected(id,nid):
							map.connect_points(id,nid)
					# Break connections to neighbors
					else:
						if map.are_points_connected(id,nid):
							map.disconnect_points(id,nid)
		# remove the cell off the list
		cells.remove_and_collide(0)
		dirty_cells.erase(cell)
		


func build_map(bounds,cells):
	BOUNDS = bounds
	floor_cells = cells
	map.clear()
	for cell in cells:
		map.add_point(xy_to_id(cell), Vector3(cell.x,cell.y,0))
	# Scan a grid..
	for x in range(BOUNDS.x):
		for y in range(BOUNDS.y):
			var p = Vector2(x,y)
			# if origin is floor
			if p in cells:
				# Scan neighbors..
				for nx in range(-1,2):
					for ny in range(-1,2):
						var np = Vector2(p.x+nx, p.y+ny)
						# if neighbor is also floor..
						if np in cells:
							var pid = xy_to_id(p)
							var nid = xy_to_id(np)
							# Create new connections
							
							if pid != nid and not map.are_points_connected(nid,pid):
								map.connect_points(pid,nid)
