extends Node2D

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
	if event is InputEventKey and event.pressed:
		var UP = event.scancode == KEY_UP
		var DOWN = event.scancode == KEY_DOWN
		var LEFT = event.scancode == KEY_LEFT
		var RIGHT = event.scancode == KEY_RIGHT
		
		if UP:
			step(Vector2(0,-1))
		if DOWN:
			step(Vector2(0,1))
		if LEFT:
			step(Vector2(-1,0))
		if RIGHT:
			step(Vector2(1,0))