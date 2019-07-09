extends TileMap

var fov_cells # Set by Fogmap

func new_map():
	var portal_room
	# Generate a dungeon
	DungeonGen.generate()
	# Place the exit
	DungeonGen.place_exit_portal(DungeonGen.last_room)
	# build a Pathfinding map
	PathGen.build_map(GameData.MAP_SIZE,DungeonGen.get_floor_cells())
	# paint the visual map
	draw_map()

func save():
	var data = {}
	# Dungeon RNG seed
	data.dungeon_rng = GameData.dungeonRNG
	# Enemy RNG seed
	data.enemy_rng = GameData.enemyRNG
	# Number of moves
	data.player_moves = GameData.player_moves
	# torch timer
	data.player_view = GameData.player_view
	data.getting_dimmer = GameData.getting_dimmer
	data.torch_timer = GameData.torch_timer
	data.light_circle = GameData.light_circle
	data.colr = GameData.colr
	data.colg = GameData.colg
	data.colb = GameData.colb
	# map data
	data.datamap = DungeonGen.datamap
	data.fogmap = get_node('Fogmap').get_datamap()
	return data

func restore(data):
	GameData.dungeonRNG = data.dungeon_rng
	GameData.enemyRNG = data.enemy_rng
	GameData.player_moves = data.player_moves
	GameData.player_view = data.player_view
	GameData.getting_dimmer = data.getting_dimmer
	GameData.torch_timer = int(data.torch_timer)
	GameData.light_circle = data.light_circle
	GameData.colr = data.colr
	GameData.colg = data.colg
	GameData.colb = data.colb
	if 'datamap' in data:
		DungeonGen.datamap = data.datamap
	if 'fogmap' in data:
		get_node('Fogmap').reveal_from_data(data.fogmap)
	draw_map()

func restore_object(data):
	var ob = load(data.filename)
	var pos = Vector2(data.x, data.y)
	if ob:
		ob = ob.instance().spawn(self,pos)
		ob.restore(data)
		return ob

func spawn_object(partial_path,cell):
	var path = 'res://objects/' +partial_path+ '.tscn'
	var ob = load(path)
	if ob: ob.instance().spawn(self,cell)

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
		if obj.get_parent() == GameData.map and obj.get_map_pos() == cell:
			list.append(obj)
	return list

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

func is_wall(cell):
	return DungeonGen.get_cell_data(cell) == 1


func spawn_fx(texture, cell):
	var fx = Sprite.new()
	fx.set_centered(false)
	fx.set_texture(texture)
	add_child(fx)
	fx.set_pos( map_to_world(cell) )
	fx.add_to_group('fx')

func spawn_inferno_fx(cell):
	var fx = load("res://graphics/particles/Flames.tscn")
	var scene_instance = fx.instance()
	scene_instance.set_name("fx")
	add_child(scene_instance)
	scene_instance.set_pos(map_to_world(cell))

func spawn_lightningbolt_fx(target):
	var bolt = load("res://graphics/particles/electricity.tscn").instance()
	bolt.init(target)
	get_parent().add_child(bolt)
	bolt.add_to_group('fx')

func spawn_necrotic_energy_fx(necromancer):
	var bolt = load("res://graphics/particles/necro_energy.tscn").instance()
	bolt.init(necromancer)
	get_parent().add_child(bolt)
	bolt.add_to_group('fx')

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
			text = "wall" if is_wall(cell) else "floor"

	set_cursor_label(text)

func _sort_z(a,b):
	if a.get_z() > b.get_z():
		return true
	return false


func set_cursor_label(text=''):
	get_node('Cursor/Label').set_text(text)

func _ready():
	GameData.map = self


func _on_player_acted():
	GameData.player_moves += 1 # increment counter for No of moves made
	GameData.torch_timer += 1 #  increment counter for burning torch
	# check state of torch light
	if GameData.torch_timer > 100 && GameData.getting_dimmer != 2:
		if GameData.getting_dimmer == 0:
			dim_the_lights()
		else:
			if GameData.torch_timer % 50 == 0:
				darker()
	# process active actors
	for node in get_tree().get_nodes_in_group('actors'):
		if node != GameData.player and node.ai and node.discovered:
			node.ai.take_turn()
		# tick down status effects
		node.fighter.process_status_effects()
	if GameData.player.fighter.has_status_effect('poisoned'):
			GameData.player.fighter.take_damage('Poison', 1)
	# remove Green poison colour from player if not poisoned
	if !GameData.player.fighter.has_status_effect('poisoned'):
		GameData.player.get_node('Glyph').add_color_override("default_color", Color(0.870588,1,0,1))
	# process FX objects
	for node in get_tree().get_nodes_in_group('fx'):
		if node.has_meta('kill'):
			node.queue_free() #kill me this turn
		else:
			node.set_meta('kill',true) #kill me next turn
	# Check XP for level progression
	var level = GameData.player.fighter.character_level
	if GameData.player.fighter.xp > ((level*150)+100):
		level_up(level)


func level_up(level):
	# Increase level
	level += 1
	GameData.player.fighter._set_character_level(level)
	# Increase max health 20%
	var newmax = floor((GameData.player.fighter.max_hp/100.0)*20) + GameData.player.fighter.max_hp
	GameData.player.fighter.max_hp = newmax
	# Increase current HP
	var boost = floor((GameData.player.fighter.hp/100.0)*20)+20
	GameData.player.fighter.heal_non_random("Leveling up", boost)
	var level_up_screen = get_node('/root/Game/LevelUp')
	get_tree().set_pause(true)
	level_up_screen.show()
	level_up_screen.start(level)

func dim_the_lights():
	GameData.getting_dimmer = 1
	GameData.player.get_node("Torch").dim_light()
	GameData.broadcast_torch("Your torch begins to flicker, the flames die down")

func darker():
	if GameData.player_view > 1:
		GameData.player_view -=1
		GameData.player.get_node("Torch").darker()
		GameData.broadcast_torch("The light grows dimmer")
	else:
		GameData.getting_dimmer = 2
		GameData.player.get_node("Torch").total_darkness()
		GameData.broadcast_torch("Your torch is extinguished...")