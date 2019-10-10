extends TileMap

var fov_cells # Set by Fogmap

func new_map():
	var portal_room
	# Generate a dungeon
	DungeonGen.generate()
	# build a Pathfinding map
	PathGen.build_map(GameData.MAP_SIZE,DungeonGen.get_floor_cells())
	# paint the visual map
	draw_map()

func save():
	var data = {}
	# Dungeon RNG seed
	data.dungeon_theme_array = GameData.dungeon_theme_array
	data.keeplvl = GameData.keeplvl
	# Enemy RNG seed
	data.enemy_rng = GameData.enemyRNG
	# Number of moves
	data.player_moves = GameData.player_moves
	data.player_radius = GameData.player_radius
	data.original_player_radius = GameData.original_player_radius
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
	GameData.keeplvl = data.keeplvl
	GameData.dungeon_theme_array = data.dungeon_theme_array
	GameData.enemyRNG = data.enemy_rng
	GameData.player_moves = data.player_moves
	GameData.original_player_radius = data.original_player_radius
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
	var theme = DungeonThemes.dung_themes[GameData.dungeon_theme_array[GameData.keeplvl-1]]
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

func spawn_vampiric_drain_fx():
	var vampiric_drain = load("res://graphics/particles/blood_drain.tscn")
	var scene_instance = vampiric_drain.instance()
	scene_instance.set_name("Vampiric drain")
	add_child(scene_instance)
	scene_instance.set_pos(map_to_world(GameData.player.get_map_pos()))

func spawn_voodoo_fx():
	var voodoo_particles = load("res://graphics/particles/voodoo_particles.tscn")
	var scene_instance = voodoo_particles.instance()
	scene_instance.set_name("Voodoo magic")
	add_child(scene_instance)
	scene_instance.set_pos(map_to_world(GameData.player.get_map_pos()))

func spawn_hell_hound(hound_pos):
	var hell_hound = load("res://objects/monsters/undead/lvl3/hell_hound.tscn").instance()
	hell_hound.set_name("Hell Hound")
	get_parent().get_node('Map').add_child(hell_hound)
	hell_hound.set_pos(hound_pos)
	hell_hound.set_z(GameData.LAYER_ACTOR)
	hell_hound.add_to_group('actors')
	hell_hound.fighter.hp = GameData.roll(15, 25)
	GameData.broadcast("The body of the puppy transforms in the flames")

func spawn_rock(npc, npc_pos):
	var rock_scene = preload("res://objects/items/Rock.tscn")
	var rock = rock_scene.instance()
	get_parent().get_node('Map').add_child(rock)
	rock.set_pos(npc_pos)
	rock.add_to_group('objects')
	rock.item.npc_throw(npc, npc_pos)

func release_blue_spores(target_area):
	var x
	var y
	var fungus_pos
	for i in range(GameData.roll(1, 2)): # Clamp to keep within the map boundaries
		x = clamp(GameData.roll(target_area.x+2, target_area.x-2), 1, GameData.MAP_SIZE.x-1)
		y = clamp(GameData.roll(target_area.y+2, target_area.y-2), 1, GameData.MAP_SIZE.y-1)
		fungus_pos = Vector2(x,y)
	# stop fungus being placed on top of walls
		while is_cell_blocked(fungus_pos):
			x = clamp(GameData.roll(target_area.x+2, target_area.x-2), 1, GameData.MAP_SIZE.x-1)
			y = clamp(GameData.roll(target_area.y+2, target_area.y-2), 1, GameData.MAP_SIZE.y-1)
			fungus_pos = Vector2(x,y)
		var blue_fungus = load("res://objects/monsters/fungus/blue_fungus.tscn").instance()
		blue_fungus.set_name("Blue fungus")
		get_parent().get_node('Map').add_child(blue_fungus)
		blue_fungus.set_pos(map_to_world(fungus_pos))
		blue_fungus.set_z(GameData.LAYER_ACTOR)
		blue_fungus.add_to_group('actors')
		blue_fungus.fighter.hp = 10
	GameData.broadcast("The fungus releases spores into the air", GameData.COLOUR_POISON_GREEN)

func release_green_spores(target_area):
	var x
	var y
	var fungus_pos
	for i in range(GameData.roll(2, 3)): # Clamp to keep within the map boundaries
		x = clamp(GameData.roll(target_area.x+2, target_area.x-2), 1, GameData.MAP_SIZE.x-1)
		y = clamp(GameData.roll(target_area.y+2, target_area.y-2), 1, GameData.MAP_SIZE.y-1)
		fungus_pos = Vector2(x,y)
	# stop fungus being placed on top of walls
		while is_cell_blocked(fungus_pos):
			x = clamp(GameData.roll(target_area.x+2, target_area.x-2), 1, GameData.MAP_SIZE.x-1)
			y = clamp(GameData.roll(target_area.y+2, target_area.y-2), 1, GameData.MAP_SIZE.y-1)
			fungus_pos = Vector2(x,y)
		var green_fungus = load("res://objects/monsters/fungus/green_fungus.tscn").instance()
		green_fungus.set_name("Green fungus")
		get_parent().get_node('Map').add_child(green_fungus)
		green_fungus.set_pos(map_to_world(fungus_pos))
		green_fungus.set_z(GameData.LAYER_ACTOR)
		green_fungus.add_to_group('actors')
		green_fungus.fighter.hp = 10
	GameData.broadcast("The fungus releases spores into the air", GameData.COLOUR_POISON_GREEN)

func spawn_mushroom_goblin(mushroom_pos):
	var mushroom_person = load("res://objects/monsters/fungus/lvl2/mushroom_person.tscn").instance()
	mushroom_person.set_name("Mushroom person")
	get_parent().get_node('Map').add_child(mushroom_person)
	mushroom_person.set_pos(mushroom_pos)
	mushroom_person.set_z(GameData.LAYER_ACTOR)
	mushroom_person.add_to_group('actors')
	mushroom_person.fighter.hp = GameData.roll(15, 20)
	GameData.broadcast("The body of the goblin twists and bursts into a walking fungus")

# Shadow demon spawned when the torch goes out
func spawn_shadow():
	var target_area = GameData.player.get_map_pos()
	var x
	var y
	var shadow_pos
	var message = ["Something stirs nearby...", "You hear a scratching in the dark...", "A low growling reaches your ears..."]
	for i in range(GameData.roll(1, 2)): # Clamp to keep within the map boundaries
		x = clamp(GameData.roll(target_area.x+2, target_area.x-2), 1, GameData.MAP_SIZE.x-1)
		y = clamp(GameData.roll(target_area.y+2, target_area.y-2), 1, GameData.MAP_SIZE.y-1)
		shadow_pos = Vector2(x,y)
		# Stop shadow being placed on walls
	while is_cell_blocked(shadow_pos):
		x = clamp(GameData.roll(target_area.x+2, target_area.x-2), 1, GameData.MAP_SIZE.x-1)
		y = clamp(GameData.roll(target_area.y+2, target_area.y-2), 1, GameData.MAP_SIZE.y-1)
		shadow_pos = Vector2(x,y)
	var shadow = load("res://objects/monsters/shadow.tscn").instance()
	shadow.set_name("Shadow")
	get_parent().get_node('Map').add_child(shadow)
	shadow.set_pos(map_to_world(shadow_pos))
	shadow.set_z(GameData.LAYER_ACTOR)
	shadow.add_to_group('actors')
	shadow.fighter.hp = 5000
	var mno = GameData.roll(0,2)
	GameData.broadcast(message[mno])

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
	if GameData.torch_timer > 200 && GameData.getting_dimmer != 2:
		if GameData.getting_dimmer == 0:
			dim_the_lights()
		else:
			if GameData.torch_timer % 50 == 0:
				darker()
	if GameData.torch_timer > 200 && GameData.getting_dimmer == 2:
		GameData.player.fighter.take_damage("A black shape", 20)
	# process active actors
	for node in get_tree().get_nodes_in_group('actors'):
		if node != GameData.player and node.ai and node.discovered:
			node.ai.take_turn()
		# tick down status effects
		node.fighter.process_status_effects()
	if GameData.player.fighter.has_status_effect('poisoned'):
			var damage = GameData.roll(1, 10)
			GameData.player.fighter.take_damage('Poison', damage)
	# remove colour from player if no status effect
	if !GameData.player.fighter.has_status_effect('poisoned') && !GameData.player.fighter.has_status_effect('paralysed'):
		GameData.player.get_node('Glyph').add_color_override("default_color", Color(0.870588,1,0,1))
	# remove effects of stealth potion
	if !GameData.player.fighter.has_status_effect('stealth') && GameData.player_radius == 1:
		GameData.broadcast("The stealth potion wears off...", GameData.COLOUR_GREEN)
		GameData.player_radius = GameData.original_player_radius
	# process FX objects
	for node in get_tree().get_nodes_in_group('fx'):
		if node.has_meta('kill'):
			node.queue_free() #kill me this turn
		else:
			node.set_meta('kill',true) #kill me next turn
	# Check XP for level progression
	var level = GameData.player.fighter.character_level
	if GameData.player.fighter.xp > ((level*150)+50):
		level_up(level)

# Increase player level
func level_up(level):
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

# Torch starts going out
func dim_the_lights():
	GameData.getting_dimmer = 1
	GameData.player.get_node("Torch").dim_light()
	GameData.broadcast_torch("Your torch begins to flicker, the flames die down")

# Torchlight gets darker
func darker():
	if GameData.player_view > 1:
		GameData.player_view -=1
		GameData.player.get_node("Torch").darker()
		GameData.broadcast_torch("The light grows dimmer")
	else: # Torch goes out and an unseen monster attacks
		GameData.getting_dimmer = 2
		GameData.player.get_node("Torch").total_darkness()
		GameData.broadcast_torch("Your torch is extinguished...")
		spawn_shadow()
