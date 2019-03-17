extends TileMap

# Basic Map
# -1=nocell, 0=Wall, 1=Floor

# Spawn what path from Database, set position to where
func spawn( what, where ):
	# Add the Thing to the scene and set its pos
	add_child( what )
	what.set_map_position( where )

func is_blocked(cell):
	return get_cellv(cell)==1

func _ready():
	# Test objects
	var player = RPG.make_thing( "player/player" )
	var potion1 = RPG.make_thing( "props/potion_red" )
	var potion2 = RPG.make_thing( "props/potion_red" )
	spawn( potion1, Vector2( 1,4 ) )
	spawn( potion2, Vector2( 10,4 ) )
	spawn( player, Vector2( 8,4 ) )