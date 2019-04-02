extends Node2D

signal object_moved(me)
signal object_acted()

export(String, MULTILINE) var name = "OBJECT"
export(bool) var blocks_movement = false

export(bool) var stay_visible = false

var seen = false setget _set_seen
var discovered = false # becomes true the first time seen becomes true

# Components
var fighter

func kill():
	if RPG.player != self:
		queue_free()

func spawn(map,cell):
	map.add_child(self)
	set_map_pos(cell)

func wait():
	emit_signal('object_acted')

# Step 1 tile in a direction
# or bump into a blocking Object
func step(dir):
	dir.x = clamp(dir.x, -1, 1)
	dir.y = clamp(dir.y, -1, 1)
	var new_cell = get_map_pos() + dir
	var blocker = RPG.map.is_cell_blocked(new_cell)
	if typeof(blocker)==TYPE_OBJECT:
		if blocker.fighter:
			fighter.fight(blocker)
			emit_signal('object_acted')
	elif blocker==false:
		set_map_pos(new_cell)
		emit_signal('object_acted')


# Set our position in map cell coordinates
func set_map_pos(cell):
	set_pos(RPG.map.map_to_world(cell))
	emit_signal('object_moved',self)

# Get our position in map cell coordinates
func get_map_pos():
	return RPG.map.world_to_map(get_pos())




func _ready():
	add_to_group('objects')
		
		
func _set_seen(what):
	seen = what
	set_hidden(not seen)
	# Discover if seen for the first time
	if seen and not discovered:
		discovered = true