extends Node2D

onready var map = get_parent()

# Name of the object
export(String, MULTILINE) var objectName = "Something"

# Does the object block player movement
export(bool) var blocks_movement = false

# Get our position in map cell coordinates
func get_map_position():
	return map.world_to_map(get_position())

# Set our position in map cell coordinates
func set_map_position(cell):
	set_position(map.map_to_world(cell))