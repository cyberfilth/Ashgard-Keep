extends Node2D

# signals
signal name_changed(what)
signal object_moved(me)
signal object_acted()

export(String, MULTILINE) var name = "OBJECT" setget _set_name
export(bool) var blocks_movement = false

export(bool) var stay_visible = false

var seen = false setget _set_seen
var discovered = false # becomes true the first time seen becomes true

# Components
var item
var fighter
var ai

func kill():
	if RPG.player != self:
		queue_free()

func spawn(map,cell):
	map.add_child(self)
	set_map_pos(cell)
	if fighter:
		fighter.fill_hp()

#func wait():
#	emit_signal('object_acted')

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
		if blocks_movement:
			# declare dirty path cell
			PathGen.dirty_cells[get_map_pos()]=true
		set_map_pos(new_cell)
		emit_signal('object_acted')

func step_to(cell):
	var pos = get_map_pos()
	var path = PathGen.find_path(pos, cell)
	if path.size() > 1:
		var dir = path[1] - pos
		step(dir)

func distance_to(cell):
	var line = FOVGen.get_line(get_map_pos(), cell)
	return line.size() - 1

# Set our position in map cell coordinates
func set_map_pos(cell):
	set_pos(RPG.map.map_to_world(cell))
	if blocks_movement:
		# declare dirty path cell
		PathGen.dirty_cells[cell]=false
	emit_signal('object_moved',self)

# Get our position in map cell coordinates
func get_map_pos():
	return RPG.map.world_to_map(get_pos())

# Get our Icon texture
func get_icon():
	return get_node('Sprite').get_texture()

func _ready():
	add_to_group('objects')

	
	if fighter:
		set_z(RPG.LAYER_ACTOR)
	else:
		set_z(RPG.LAYER_ITEM)

func _set_name(what):
	name = what
	emit_signal('name_changed', name)

func _set_seen(what):
	seen = what
	set_hidden(not seen)
	# Discover if seen for the first time
	if seen and not discovered and not self==RPG.player:
		discovered = true
		RPG.broadcast("A " +self.name+ " has been found", RPG.COLOR_YELLOW)

func _on_hp_changed(current,full):
	if not fighter: return
	get_node('HPBar').set_hidden(current >= full)
	get_node('HPBar').set_max(full)
	get_node('HPBar').set_value(current)