extends Node2D

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

onready var map = get_parent()

# Step 1 tile in a direction
func step(dir):
	dir.x = clamp(dir.x, -1, 1)
	dir.y = clamp(dir.y, -1, 1)
	var new_cell = get_map_position() + dir
	if not map.is_blocked(new_cell):
		set_map_position(new_cell)
	else:
		print("You walk into the wall.")

# Set our position in map cell coordinates
func set_map_position(cell):
	set_position(map.map_to_world(cell))

# Get our position in map cell coordinates
func get_map_position():
	return map.world_to_map(get_position())

func _ready():
	set_process_input(true)

func _input(event):
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