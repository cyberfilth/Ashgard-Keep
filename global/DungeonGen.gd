extends Node

# square room 13x13
const PREFAB_13x13 = [
[0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,1,1,1,1,0,0,0,1,1,1,1,0],
[0,1,0,0,1,0,0,0,1,0,0,1,0],
[0,1,0,0,1,0,0,0,1,0,0,1,0],
[0,1,0,0,1,0,1,0,1,0,0,1,0],
[0,0,0,0,0,0,1,0,0,0,0,0,0],
[0,0,0,0,0,0,1,0,0,0,0,0,0],
[0,0,0,0,0,0,1,0,0,0,0,0,0],
[0,1,0,0,1,0,1,0,1,0,0,1,0],
[0,1,0,0,1,0,0,0,1,0,0,1,0],
[0,1,0,0,1,0,0,0,1,0,0,1,0],
[0,1,1,1,1,0,0,0,1,1,1,1,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0],
]

# square room 10x10
const PREFAB_10x10 = [
[0,0,0,0,0,0,0,0,0,0],
[0,0,1,0,0,0,0,1,0,0],
[0,1,0,0,0,0,0,0,1,0],
[0,0,1,0,0,0,0,1,0,0],
[0,0,0,0,1,1,0,0,0,0],
[0,0,0,0,1,1,0,0,0,0],
[0,0,1,0,0,0,0,1,0,0],
[0,1,0,0,0,0,0,0,1,0],
[0,0,1,0,0,0,0,1,0,0],
[0,0,0,0,0,0,0,0,0,0],
]

# circular room 9x9
const PREFAB_9x9 = [
[0,0,0,0,0,0,0,0,0],
[0,0,0,1,1,1,0,0,0],
[0,0,1,0,0,0,1,0,0],
[0,1,0,0,0,0,0,1,0],
[0,1,0,0,0,0,0,1,0],
[0,1,0,0,0,0,0,1,0],
[0,0,1,0,0,0,1,0,0],
[0,0,0,1,1,1,0,0,0],
[0,0,0,0,0,0,0,0,0],
]

# square room 8x8
const PREFAB_8x8 = [
[0,0,0,0,0,0,0,0],
[0,1,0,0,0,0,1,0],
[0,0,0,0,0,0,0,0],
[0,0,0,1,1,0,0,0],
[0,1,0,0,0,0,1,0],
[0,0,0,0,0,0,0,0],
[0,1,0,1,1,0,1,0],
[0,0,0,0,0,0,0,0],
]

var datamap = []
var start_pos = Vector2()
var monster_theme
var item_theme
var trap_theme
var encounter_theme
var npc_theme
var prefab_room = []

# Set dungeon theme
func set_theme():
	if GameData.enemyRNG == 0:
		monster_theme = DungeonThemes.monster_undead
		item_theme = DungeonThemes.items_undead
		trap_theme = DungeonThemes.traps_undead
		encounter_theme = DungeonThemes.npc_undead
		npc_theme = 'undead'
	elif GameData.enemyRNG == 1:
		monster_theme = DungeonThemes.monster_greenskins
		item_theme = DungeonThemes.items_greenskins
		trap_theme = DungeonThemes.traps_greenskins
		encounter_theme = DungeonThemes.npc_greenskins
		npc_theme = 'greenskins'

# Build a new datamap (fill with walls)
func build_datamap():
	var size = GameData.MAP_SIZE
	for x in range(size.x):
		var row = []
		for y in range(size.y):
			row.append(1)
		datamap.append(row)

# Set data to a cell in the datamap
func set_cell_data(cell, data):
	datamap[cell.x][cell.y] = data

func get_cell_data(cell):
	return datamap[cell.x][cell.y]

# find the center cell of a given rectangle
func center(rect):
	var x = int(rect.size.x / 2)
	var y = int(rect.size.y / 2)
	return Vector2(rect.pos.x+x, rect.pos.y+y)

 # Try and fit in prefab rooms or fall back to
 # filling a rectangle of the map with floor cells
 # leaving a 1-tile border along edges
func carve_room(rect):
	if rect.size.x == 13 && rect.size.y == 13:
		prefab_room = PREFAB_13x13
	if rect.size.x == 10 && rect.size.y == 10:
		prefab_room = PREFAB_10x10
	elif rect.size.x >= 9 && rect.size.y >= 9:
		prefab_room = PREFAB_9x9
	elif rect.size.x == 8 && rect.size.y ==8:
		prefab_room = PREFAB_8x8
	elif prefab_room.empty():
	# draw regular rectangular room
		for x in range(rect.size.x-2):
			for y in range(rect.size.y-2):
				set_cell_data(Vector2(rect.pos.x+x+1, rect.pos.y+y+1), 0)
		prefab_room = []
		return
	for x in range(prefab_room.size()):
		for y in range(prefab_room.size()):
			set_cell_data(Vector2(rect.pos.x+x, rect.pos.y+y), prefab_room[x][y])
	prefab_room = []

# Fill a horizontal strip of cells at row Y from X1 to X2
func carve_h_hall(x1,x2,y):
	for x in range( min( x1, x2 ),max( x1,x2 ) + 1 ):
		set_cell_data( Vector2(x, y), 0 )
	var mid_x = (x1+x2)/2
	place_corridor_monsters(mid_x, y)

# Fill a vertical strip of cells at column X from Y1 to Y2
func carve_v_hall( y1, y2, x):
	for y in range( min( y1, y2 ),max( y1, y2 ) + 1 ):
		set_cell_data( Vector2(x, y), 0 )
	var mid_y = (y1+y2)/2
	place_corridor_monsters(x, mid_y)

func get_floor_cells():
	var list = []
	for x in range(GameData.MAP_SIZE.x):
		for y in range(GameData.MAP_SIZE.y):
			if datamap[x][y] == 0:
				list.append(Vector2(x,y))
	return list

func generate():
	datamap.clear() # Resets datamap when generating new level
	build_datamap()
	set_theme()
	var rooms = []
	var num_rooms = 0
	for r in range(GameData.MAX_ROOMS):
		# width & height of room
		var w = GameData.roll(GameData.ROOM_MIN_SIZE, GameData.ROOM_MAX_SIZE)
		var h = GameData.roll(GameData.ROOM_MIN_SIZE, GameData.ROOM_MAX_SIZE)
		# origin (top-left corner)
		var x = GameData.roll(2, GameData.MAP_SIZE.x-1 - w-1)
		var y = GameData.roll(2, GameData.MAP_SIZE.y-1 - h-1)
		var new_room = Rect2(x,y,w,h)
		var fail = false
		for other_room in rooms:
			if other_room.intersects(new_room):
				fail = true
				break
		if !fail:
			carve_room(new_room)
			var new_center = center(new_room)
			if num_rooms == 0:
				start_pos = new_center
			else:
				var prev_center = center(rooms[num_rooms-1])
				# flip a coin
				if randi()%2 == 0:
					# go horizontal then vertical
					carve_h_hall(prev_center.x, new_center.x, prev_center.y)
					carve_v_hall(prev_center.y, new_center.y, new_center.x)
				else:
					# go vertical then horizontal
					carve_v_hall(prev_center.y, new_center.y, prev_center.x)
					carve_h_hall(prev_center.x, new_center.x, new_center.y)
			rooms.append(new_room)
			num_rooms += 1
	# Place monsters & items in every room except starting room
	var trap = rooms.size()/2
	var encounter = rooms.size()/3
	for z in range(1, rooms.size()):
		# don't place trap / encounter in same room as monster
		if z != trap && z != encounter:
			place_monsters(rooms[z])
			place_items(rooms[z])
	place_exit_portal(rooms[rooms.size()-1])
	place_trap(rooms[trap])
	place_encounter(rooms[encounter])
	#map_to_text()

# Saves generated dungeon as a text file
func map_to_text():
	var file = File.new()
	file.open('res://map.txt',File.WRITE)
	for row in datamap:
		var t = ''
		for col in row:
			t += str([' ','#'][col])
		file.store_line(t)
	file.close()

# traps
func place_trap(room):
	var traps_list = trap_theme[GameData.keeplvl-1]
	var traps_choice = [traps_list.t_e1, traps_list.t_e2]
	var choice = traps_choice[GameData.roll(0, traps_choice.size()-1)]
	var x = GameData.roll(room.pos.x+1, room.end.x-2)
	var y = GameData.roll(room.pos.y+1, room.end.y-2)
	var pos = Vector2(x,y)
		# stops trap being placed on top of walls
	while GameData.map.is_cell_blocked(pos):
		x = GameData.roll(room.pos.x+1, room.end.x-2)
		y = GameData.roll(room.pos.y+1, room.end.y-2)
		pos = Vector2(x,y)
	GameData.map.spawn_object(choice, pos)

func place_encounter(room):
	var encounter_list = encounter_theme[GameData.keeplvl-1]
	var encounter_choice = [encounter_list.t_e1, encounter_list.t_e2]
	var choice = encounter_choice[GameData.roll(0, encounter_choice.size()-1)]
	var x = GameData.roll(room.pos.x+1, room.end.x-2)
	var y = GameData.roll(room.pos.y+1, room.end.y-2)
	var pos = Vector2(x,y)
		# stops encounter being placed on top of walls
	while GameData.map.is_cell_blocked(pos):
		x = GameData.roll(room.pos.x+1, room.end.x-2)
		y = GameData.roll(room.pos.y+1, room.end.y-2)
		pos = Vector2(x,y)
	if choice == encounter_list.t_e1:
		var npc = npc_theme
		print(npc)
		GameData.map.spawn_encounter_object(choice, pos, npc)
	else:
		GameData.map.spawn_object(choice, pos)



func place_monsters(room):
	var x = GameData.roll(room.pos.x+1, room.end.x-2)
	var y = GameData.roll(room.pos.y+1, room.end.y-2)
	var pos = Vector2(x,y)
		# stops monsters being placed on top of walls
	while GameData.map.is_cell_blocked(pos):
		x = GameData.roll(room.pos.x+1, room.end.x-2)
		y = GameData.roll(room.pos.y+1, room.end.y-2)
		pos = Vector2(x,y)
	var theme = monster_theme[GameData.keeplvl-1]
	var monsters = [theme.minion1, theme.minion2, theme.gribbly1, theme.gribbly2, theme.boss1]
	var choice = monsters[GameData.roll(0, monsters.size()-1)]
	GameData.map.spawn_object(choice, pos)

func place_corridor_monsters(x, y):
	# chance of encountering a monster
	var encounter_chance = randi()%5
	if encounter_chance == 1:
		var monster
		var pos = Vector2(x,y)
		var theme = monster_theme[GameData.keeplvl-1]
		# select which low-level monster is encountered
		var wandering_monster = randi()%2
		if wandering_monster == 0:
			monster = theme.minion1
		else:
			monster = theme.minion2
		GameData.map.spawn_object(monster, pos)

# Chooses an item based on a score 1 - 100
func probability(score):
	if score in range(1, 31):
		return 0
	elif score in range(31, 61):
		return 1
	elif score in range(61, 76):
		return 2
	elif score in range(76, 86):
		return 3
	elif score in range(86, 94):
		return 4
	else:
		return 5

func place_items(room):
	var x = GameData.roll(room.pos.x+1, room.end.x-2)
	var y = GameData.roll(room.pos.y+1, room.end.y-2)
	var pos = Vector2(x,y)
	# stops items being placed on top of walls
	while GameData.map.is_cell_blocked(pos):
		x = GameData.roll(room.pos.x+1, room.end.x-2)
		y = GameData.roll(room.pos.y+1, room.end.y-2)
		pos = Vector2(x,y)
	var theme = item_theme[GameData.keeplvl-1]
	var items = [theme.rubble, theme.healthpotion, theme.magicitem1, theme.magicitem2, theme.weapon, theme.armour]
	var probability_score = GameData.roll(1, 100)
	var choice = items[probability(probability_score)]
	GameData.map.spawn_object(choice, pos)

func place_exit_portal(room):
	var x = GameData.roll(room.pos.x+1, room.end.x-2)
	var y = GameData.roll(room.pos.y+1, room.end.y-2)
	var pos = Vector2(x,y)
		# stops portal being placed on top of walls
	while GameData.map.is_cell_blocked(pos):
		x = GameData.roll(room.pos.x+1, room.end.x-2)
		y = GameData.roll(room.pos.y+1, room.end.y-2)
		pos = Vector2(x,y)
	GameData.map.spawn_object('items/Portal', pos)