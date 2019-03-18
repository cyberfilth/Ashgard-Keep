extends "res://objects/components/Object.gd"

const DIRECTIONS = {
    "N":    Vector2(0,-1),
    "NE":    Vector2(1,-1),
    "E":    Vector2(1,0),
    "SE":    Vector2(1,1),
    "S":    Vector2(0,1),
    "SW":    Vector2(-1,1),
    "W":    Vector2(-1,0),
    "NW":    Vector2(-1,-1),
    }

# Step one cell in a direction
func step(dir):
	dir.x = clamp(dir.x, -1, 1)
	dir.y = clamp(dir.y, -1, 1)
	
	# Calculate new cell
	var new_cell = get_map_position() + dir
	 # Check for colliders at new cell
	var collider = map.get_collider( new_cell )
	if collider == map:
		print( self.objectName + " hits the wall with a thud!" )
	elif collider != null:
		print( "%s punches the %s in the face!" % [self.objectName, collider.name] )
	else:
		set_map_position( new_cell )

func _ready():
	set_process_input(true)

func _input(_event):
	if Input.is_action_pressed( "step_N" ):
		step( DIRECTIONS.N )
	if Input.is_action_pressed( "step_NE" ):
		step( DIRECTIONS.NE )
	if Input.is_action_pressed( "step_E" ):
		step( DIRECTIONS.E )
	if Input.is_action_pressed( "step_SE" ):
		step( DIRECTIONS.SE )
	if Input.is_action_pressed( "step_S" ):
		step( DIRECTIONS.S )
	if Input.is_action_pressed( "step_SW" ):
		step( DIRECTIONS.SW )
	if Input.is_action_pressed( "step_W" ):
		step( DIRECTIONS.W )
	if Input.is_action_pressed( "step_NW" ):
		step( DIRECTIONS.NW )