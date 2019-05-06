extends TileMap

var fov_cells # Set by Fogmap

func save():
	var data = {}
	data.datamap = DungeonGen.datamap
	data.fogmap = get_node('Fogmap').get_datamap()
	return data

func get_objects_in_fov():
	var list = []
	for obj in get_tree().get_nodes_in_group('objects'):
		if obj.get_map_pos() in fov_cells:
			list.append(obj)
	return list

func get_actor_in_cell(cell):
	var list = self.get_objects_in_cell(cell)
	for obj in list:
		if obj.is_in_group('actors'):
			return obj

func get_nearest_visible_actor():
	# Get visible objects
	var actors = []
	for obj in get_objects_in_fov():
		if obj.is_in_group('actors') and obj != GameData.player:
			actors.append(obj)
	# drop out if no actors visible
	if actors.empty():
		return null
	# keep track of nearest object and its distance
	var nearest = actors[0]
	var distance = nearest.distance_to(GameData.player.get_map_pos())
	# compare all actors against nearest, replace if nearer
	for actor in actors:
		var D = actor.distance_to(GameData.player.get_map_pos())
		if D < distance:
			nearest = actor
			distance = D
	# return nearest
	return nearest


func spawn_object(partial_path,cell):
	var path = 'res://objects/' +partial_path+ '.tscn'
	var ob = load(path)
	if ob: ob.instance().spawn(self,cell)

func spawn_fx(texture, cell):
	var fx = Sprite.new()
	fx.set_centered(false)
	fx.set_texture(texture)
	add_child(fx)
	fx.set_pos( map_to_world(cell) )
	fx.add_to_group('fx')

# Set the Darkness Canvas item 
# colour to complement each dungeon tileset
func draw_map():
	var theme = DungeonThemes.themes[GameData.dungeonRNG]
	var family = theme.tileset
	get_node("Darkness").set_color(theme.darkness)
	var datamap = DungeonGen.datamap
	for x in range(datamap.size()-1):
		for y in range(datamap[x].size()-1):
			var tile = datamap[x][y]
			var idx = -1
			if tile == 0: # Floor
				idx = GameData.roll(family[0][0],family[0][1])
			elif tile == 1:
				idx = GameData.roll(family[1][0],family[1][1])
			set_cell(x,y,idx)

# Return True if cell is a wall
# Return False if cell is an unblocked floor
# Return Object if cell has a blocking Object
func is_cell_blocked(cell):
	var blocks = is_wall(cell)
	var objects = get_objects_in_cell(cell)
	for obj in objects:
		if obj.blocks_movement:
			blocks = obj
	return blocks

func get_objects_in_cell(cell):
	var list = []
	for obj in get_tree().get_nodes_in_group('objects'):
		if obj.get_map_pos() == cell:
			list.append(obj)
	return list

func is_wall(cell):
	return DungeonGen.get_cell_data(cell) == 1

func set_cursor_hidden(is_hidden):
	get_node('Cursor').set_hidden(is_hidden)

func set_cursor():
	var cell = world_to_map(get_local_mouse_pos())
	get_node('Cursor').set_pos(map_to_world(cell))
	
	var oob = false # out of bounds
	if cell.x < 0 or cell.x >= GameData.MAP_SIZE.x: oob = true
	if cell.y < 0 or cell.y >= GameData.MAP_SIZE.y: oob = true

	var text = 'NO!' #<-- shouldn't see this in game
	
	if cell in get_node('Fogmap').get_used_cells() or oob:
		# cursor in fog or out of map
		text = 'Unseen'
	else:
		var list = get_objects_in_cell(cell)
		# cursor over object
		if !list.empty():
			list.sort_custom(self,'_sort_z')
			text = list[0].get_display_name()
		else:
			# cursor over empty wall/floor
			text = "A wall" if is_wall(cell) else "A floor"

	set_cursor_label(text)

func _sort_z(a,b):
	if a.get_z() > b.get_z():
		return true
	return false

func set_cursor_label(text=''):
	get_node('Cursor/Label').set_text(text)

func _ready():
	var portal_room
	GameData.map = self
	# Generate a dungeon
	DungeonGen.generate()
	# Place the exit
	DungeonGen.place_exit_portal(DungeonGen.last_room)
	# Output dungeon to text
	DungeonGen.map_to_text()
	# build a Pathfinding map
	PathGen.build_map(GameData.MAP_SIZE,DungeonGen.get_floor_cells())
	# paint the visual map
	draw_map()

func _on_player_acted():
	# process active actors
	for node in get_tree().get_nodes_in_group('actors'):
		if node != GameData.player and node.ai and node.discovered:
			node.ai.take_turn()
		# tick down status effects
		node.fighter.process_status_effects()
	# process FX objects
	for node in get_tree().get_nodes_in_group('fx'):
		if node.has_meta('kill'):
			node.queue_free()	#kill me this turn
		else:
			node.set_meta('kill',true)	#kill me next turn
