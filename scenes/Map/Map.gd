extends TileMap

func spawn_object(partial_path,cell):
	var path = 'res://objects/' +partial_path+ '.tscn'
	var ob = load(path)
	if ob: ob.instance().spawn(self,cell)

func draw_map():
	var family = TileFamily.FAMILY_SANDSTONE
	var datamap = DungeonGen.datamap
	for x in range(datamap.size()-1):
		for y in range(datamap[x].size()-1):
			var tile = datamap[x][y]
			var idx = -1
			if tile == 0: # Floor
				idx = RPG.roll(family[0][0],family[0][1])
			elif tile == 1:
				idx = RPG.roll(family[1][0],family[1][1])
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
	if cell.x < 0 or cell.x >= RPG.MAP_SIZE.x: oob = true
	if cell.y < 0 or cell.y >= RPG.MAP_SIZE.y: oob = true

	var text = 'NO!' #<-- shouldn't see this in game
	
	if cell in get_node('Fogmap').get_used_cells() or oob:
		# cursor in fog or out of map
		text = 'Unseen'
	else:
		var list = get_objects_in_cell(cell)
		# cursor over object
		if !list.empty():
			list.sort_custom(self,'_sort_z')
			text = list[0].name
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
	RPG.map = self
	# Generate a dungeon
	DungeonGen.generate()
	# Output dungeon to text
	#DungeonGen.map_to_text()
	# build a Pathfinding map
	PathGen.build_map(RPG.MAP_SIZE,DungeonGen.get_floor_cells())
	# paint the visual map
	draw_map()

func _on_player_acted():	
	for node in get_tree().get_nodes_in_group('actors'):
		if node != RPG.player and node.ai and node.discovered:
			node.ai.take_turn()