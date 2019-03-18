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
			# Return the blocking Thing at this map pos
			return object
		# Else return me if hitting a wall, or null if hitting air
		return self if not is_blocked( cell ) else null

func is_blocked(cell):
	return get_cellv(cell)==1

# Return TRUE if cell is blocked by anything
func is_cell_blocked(cell):
	for object in get_blockers():
		if object.get_map_position() == cell:
			return true
	# if no blockers here, check for walls
	return is_blocked(cell)

func _ready():
	# Test objects
	var player = RPG.make_object( "player/player" )
	var potion1 = RPG.make_object( "props/potion_red" )
	var potion2 = RPG.make_object( "props/potion_red" )
	spawn( potion1, Vector2( 4,4 ) )
	spawn( potion2, Vector2( 10,4 ) )
	spawn( player, Vector2( 8,4 ) )