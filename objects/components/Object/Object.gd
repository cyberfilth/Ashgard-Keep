extends Node2D

# signals
signal name_changed(what)
signal object_moved(me)
signal object_acted()

export(String, MULTILINE) var name = "OBJECT" setget _set_name

export(bool) var proper_name = false
export(bool) var blocks_movement = false
export(bool) var stay_visible = false

var seen = false setget _set_seen
var discovered = false # becomes true the first time seen becomes true

# Components
var item
var fighter
var ai

func save():
	var data = {}
	data.name = self.name
	data.proper_name = self.proper_name
	data.filename = get_filename()
	var pos = get_map_pos()
	data.x = pos.x
	data.y = pos.y
	data.discovered = discovered
	if item:
		data.item = item.save()
	if fighter:
		data.fighter = fighter.save()
	return data

func restore(data, on_map=true):
	if 'name' in data:
		self.name = data.name
	if 'proper_name' in data:
		self.proper_name = data.proper_name
	if 'discovered' in data:
		self.discovered = data.discovered
		if self.discovered == false:
			_set_seen(item)
	if on_map and 'x' in data and 'y' in data:
		set_map_pos(Vector2(data.x, data.y), true)
	if item and 'item' in data:
		item.restore(data.item)
	if fighter and 'fighter' in data:
		fighter.restore(data.fighter)
		# A bit of a hack but it shows the player on game restore
		GameData.player.show()
	return self

func get_display_name():
	if self.proper_name:
		# Return name if proper noun
		return self.name.capitalize()
	var pre = "A "
	# "An" if first the letter in name is a vowel
	if self.name[0].to_lower() in ['a','e','i','o','u']:
		pre = "An "
	return pre + self.name

func kill():
	if GameData.player != self:
		queue_free()


func spawn(map,cell):
	if is_in_group('inventory'):
		remove_from_group('inventory')
	if !is_in_group('world'):
		add_to_group('world')
	map.add_child(self)
	set_map_pos(cell)
	if fighter:
		fighter.fill_hp()
	return self

func pickup():
	if is_in_group('world'):
		remove_from_group('world')
	if !is_in_group('inventory'):
		add_to_group('inventory')
	GameData.inventory.add_to_inventory(self)

# Step 1 tile in a direction
# or bump into a blocking Object
func step(dir):
	dir.x = clamp(dir.x, -1, 1)
	dir.y = clamp(dir.y, -1, 1)
	var new_cell = get_map_pos() + dir
	var blocker = GameData.map.is_cell_blocked(new_cell)
	if typeof(blocker)==TYPE_OBJECT:
		if blocker.fighter and blocker != self:
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
# warp=true: set position regardless of blockers 
# and don't emit moved signal
func set_map_pos(cell, warp=false):
	set_pos(GameData.map.map_to_world(cell))
	if not warp:
		if blocks_movement:
			# declare dirty path cell
			PathGen.dirty_cells[cell]=false
		emit_signal('object_moved',self)

# Get our position in map cell coordinates
func get_map_pos():
	return GameData.map.world_to_map(get_pos())

# Get our Icon texture
func get_icon():
	return get_node('Sprite').get_texture()

# Get Brand texture
func get_brand():
	return get_node('Brand').get_texture()


func _ready():
	add_to_group('objects')
	if fighter:
		set_z(GameData.LAYER_ACTOR)
	else:
		set_z(GameData.LAYER_ITEM)

func _set_name(what):
	name = what
	emit_signal('name_changed', name)


func _set_seen(what):
	seen = what
	set_hidden(not seen)
	# Discover if seen for the first time
	if seen && !discovered && !self==GameData.player:
		discovered = true
		# Stops a 'found' message being displayed for starting equipment
		if self.has_node("Item") && self.get_node("Item").equipped == true:
			pass
		else:
			GameData.broadcast("You find a " + self.get_display_name(), GameData.COLOUR_YELLOW)
		

func _on_hp_changed(current,full):
	if not fighter: return

func _on_xp_changed(what):
	if not fighter: return

func _on_character_level_changed(what):
	if not fighter: return
