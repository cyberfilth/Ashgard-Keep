extends TileMap

# Basic Map
# -1=nocell, 0=Wall, 1=Floor

# Return Array of all Objects
func get_objects():
    return get_tree().get_nodes_in_group("objects")

# Return Array of all Movement-Blocking Objects
func get_blockers():
    return get_tree().get_nodes_in_group("blockers")

# Spawn WHAT path from Database, set position to WHERE
func spawn( what, where ):
	# Add the object to the scene and set its position
	add_child( what )
	what.set_map_position( where )
	 # All objects go to objects group
	what.add_to_group("objects")
	# Add blocking objects to a blockers group
	if what.blocks_movement:
		what.add_to_group("blockers")

# Return a blocking Object, this Map, or null at cell
func get_collider( cell ):
	for object in get_blockers():
		if object.get_map_position() == cell:
			# Return the blocking Object at this map pos
			return object
		# Else return me if hitting a wall, or null if hitting air
		return self if is_blocked( cell ) else null

func is_blocked(cell):
	return get_cellv(cell) <= 9 # Walls are indexed 0 to 9

# Return TRUE if cell is blocked by anything
func is_cell_blocked(cell):
	for object in get_blockers():
		if object.get_map_position() == cell:
			return true
	# if no blockers here, check for walls
	return is_blocked(cell)

# Draw map cells from map 2DArray
func draw_map():
	var family = TileFamily.FAMILY_SANDSTONE
	var datamap = DungeonGenerator.datamap
	for y in range(datamap.size()-1):
		for x in range(datamap[y].size()-1):
			var tile = datamap[y][x]
			var idx = -1
			if tile == 0: # Floor
				idx = RPG.roll(family[0][0],family[0][1])
			elif tile == 1:
				idx = RPG.roll(family[1][0],family[1][1])
			set_cell(x,y,idx)

func _ready():
	RPG.map = self
	DungeonGenerator.generate()
	#DungeonGenerator.map_to_text()
	draw_map()
	
	# Spawn player
	var player = RPG.make_object( "player/player" )
	spawn( player, DungeonGenerator.start_pos)