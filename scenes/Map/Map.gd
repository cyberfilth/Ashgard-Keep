extends TileMap

# Basic Map
# -1=nocell, 0=Wall, 1=Floor


func spawn_object(partial_path,cell):
	var path = 'res://objects/' +partial_path+ '.tscn'
# DOESN'T WORK ON EXPORT
#	var file = File.new()
#	var exists = file.file_exists(path)
#	if not exists: 
#		OS.alert("no such object: "+path)
#		return
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
	return DungeonGen.datamap[cell.x][cell.y]==1


func _ready():
	RPG.map = self
	DungeonGen.generate()
	DungeonGen.map_to_text()
	draw_map()
	spawn_object('Player/Player',DungeonGen.start_pos)

func _on_player_acted():
	for node in get_tree().get_nodes_in_group('actors'):
		if node != RPG.player:
			print(node.name+ " gives you a dirty look!")
