extends Container

signal map_clicked(cell)

onready var messagebox = get_node('frame/left/MessageBox')
onready var playerinfo = get_node('frame/right/PlayerInfo')
onready var viewport_panel = get_node('frame/left/map')

onready var inventory_menu = get_node('InventoryMenu')

var is_mouse_in_map = false setget _set_is_mouse_in_map
var mouse_cell = Vector2() setget _set_mouse_cell

func new_game():
	GameData.keeplvl = 1
	PlotGen.generate_plot()
	GameData.set_dungeon_theme()
	GameData.set_enemy_theme()
	GameData.map.new_map()
	GameData.death_list = []
	spawn_player(DungeonGen.start_pos)
	GameData.player.name = PlotGen.username
	# Add starting equipment
	#torch
	GameData.map.spawn_object('items/torch/torch', DungeonGen.start_pos)
	GameData.player.get_node('Controller').Grab()
	# weapon
	var weapon_list = ['weapons/rusty_dagger', 'weapons/crude_dagger']
	var starting_weapon = weapon_list[GameData.roll(0, weapon_list.size()-1)]
	GameData.map.spawn_object(starting_weapon, DungeonGen.start_pos)
	GameData.player.get_node('Controller').Grab()
	get_node('frame/right/Activity/box/Inventory/InventorySlot16').emit_signal("pressed")
	# Clear status messages
	GameData.clear_messages()
	# Welcome message
	var suffix = ""
	var date_string = ""
	var time = OS.get_date()
	var dayofweek = time["weekday"]
	var month_num = time["month"]
	var date_num = time["day"]
	var year = time["year"]
	var moon_description = moon_phase(month_num, dayofweek, year)
	if date_num == 11 || date_num == 12 || date_num == 13:
		suffix = "th"
	elif (date_num % 10 == 1):
		suffix = "st"
	elif (date_num % 10 == 2):
		suffix = "nd"
	elif (date_num % 10 == 3):
		suffix = "rd"
	else:
		suffix = "th"
	date_string = str(("\n\nIt is " + GameData.TROLL_DAY[dayofweek] + ", the " + str(date_num) + suffix + " day of " + GameData.TROLL_MONTH[month_num]))
	GameData.broadcast(date_string)
	GameData.broadcast(moon_description)
	GameData.broadcast("You, "+GameData.player.name+", have entered the Keep.... Good Luck!")

func moon_phase(month, day, year):
	var ages = [18, 0, 11, 22, 3, 14, 25, 6, 17, 28, 9, 20, 1, 12, 23, 4, 15, 26, 7]
	var offsets = [-1, 1, 0, 1, 2, 3, 4, 5, 7, 7, 9, 9]
	var description = ["It is a moonless night, dark and dangerous.",\
	"A crescent moon waxes overhead.",\
	"A quarter-moon shines a dim light overhead.",\
	"A bloated, nearly full moon, hangs in the sky.",\
	"A full moon hangs in the sky tonight, its Dragon Head clearly visible.",\
	"A nearly full moon overhead, casts a pale light.",\
	"A fading, quarter moon shines a dim light.",\
	"The thin sliver of a crescent moon shines overhead."]
	var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
	if day == 31:
		day = 1
	var days_into_phase = ((ages[(year + 1) % 19] + ((day + offsets[month-1]) % 30) + (year < 1900)) % 30)
	var index = int((days_into_phase + 2) * 16/59.0)
	if index > 7:
		index = 7
	var status = description[index]
	
	# light should be 100% 15 days into phase
	var light = int(2 * days_into_phase * 100/29)
	if light > 100:
		light = abs(light - 200);
	var date = str(day)+" "+str(months[month-1])+" "+str(year)
	
	return status

# Re-equip when restoring game or entering new level
func re_equip_weapons_armour(entry, ob):
	# Equip weapon
	if entry.item.equipped == true:
		if ob.has_node('Weapon'):
			var weapon = ob.get_node('Weapon')
			ob.item.equip_weapon(weapon)
	# Equip armour
		else:
			if ob.has_node('Armour'):
				var armour = ob.get_node('Armour')
				ob.item.equip_armour(armour)

# Enter a new level of the Keep
func load_new_level():
	#GameData.set_dungeon_theme()
	GameData.set_enemy_theme()
	GameData.map.new_map()
	spawn_player(DungeonGen.start_pos)
	GameData.player.name = GameData.lvlname
	GameData.player.fighter.character_level = GameData.lvlcharacter_level
	GameData.player.fighter.attack = GameData.lvlattack
	GameData.player.fighter.defence = GameData.lvldefence
	GameData.player.fighter.max_hp = GameData.lvlmaxhp
	GameData.player.fighter.hp = GameData.lvlhp
	GameData.player.fighter.xp = GameData.lvlxp
	GameData.player.fighter.weapon_equipped = GameData.lvlweapon_equipped
	GameData.player.fighter.armour_equipped = GameData.lvlarmour_equipped
	for entry in GameData.player_inventory:
			var ob = restore_object(entry)
			ob.pickup()
			re_equip_weapons_armour(entry, ob)
	# Update floor level label
	var suffix = ""
	var keepfloor = int(GameData.keeplvl)
	if keepfloor == 11 || keepfloor == 12 || keepfloor == 13:
		suffix = "th"
	elif (keepfloor % 10 == 1):
		suffix = "st"
	elif (keepfloor % 10 == 2):
		suffix = "nd"
	elif (keepfloor % 10 == 3):
		suffix = "rd"
	else:
		suffix = "th"
	var keep_level = str(keepfloor)+suffix
	# update ui
	get_node('/root/Game/frame/right/PlayerInfo/frame/stats/right/labels/Location').set_text(keep_level+" floor")
	GameData.clear_messages()
	GameData.broadcast("\n\nYou step out of the portal...")

# Save Game Function
func save_game():
	# create a new file object to work with
	var file = File.new()
	#var opened = file.open_encrypted_with_pass(GameData.SAVEGAME_PATH, File.WRITE, GameData.ENCRYPTION_PASSWORD)
	var opened = file.open(GameData.SAVEGAME_PATH, File.WRITE)# unencrypted for testing
	# Alert and return error if file can't be opened
	if not opened == OK:
		OS.alert("Unable to access file " + GameData.SAVEGAME_PATH)
		return opened
	# Gather data to save
	var data = {}
	# version
	data.version = {
	"AshgardKeep" : GameData.version
	}
	# Game story and characters
	data.plot = PlotGen.save()
	# Enemies killed
	data.death_list = GameData.death_list
	# Map data: Datamap, Fogmap and DungeonTheme
	data.map = GameData.map.save()
	# Player object data
	data.player = GameData.player.save()
	data.objects = []
	data.inventory = []
	for node in get_tree().get_nodes_in_group('world'):
		# exclude saved player data
		if node != GameData.player:
			data.objects.append(node.save())
	for node in get_tree().get_nodes_in_group('inventory'):
		data.inventory.append(node.save())
	# Store data and close file
	file.store_line(data.to_json())
	file.close()
	# Return OK if all goes well
	return opened

# Restore Game Function
func restore_game():
	# create a new file object to work with
	var file = File.new()
	# return error if file not found
	if !file.file_exists(GameData.SAVEGAME_PATH):
		OS.alert("No file found at " + GameData.SAVEGAME_PATH)
		return ERR_FILE_NOT_FOUND
	var opened = file.open(GameData.SAVEGAME_PATH, File.READ)# unencrypted for testing
	#var opened = file.open_encrypted_with_pass(GameData.SAVEGAME_PATH, File.READ, GameData.ENCRYPTION_PASSWORD)
	# Alert and return error if file can't be opened
	if !opened == OK:
		OS.alert("Unable to access file " + GameData.SAVEGAME_PATH)
		return opened
	# Dictionary to store file data
	var data = {}
	# Parse data from json file
	while not file.eof_reached():
		data.parse_json(file.get_line())
	# Restore game from data
	# Game story and characters
	if 'plot' in data:
		PlotGen.restore(data.plot)
	
	# Number of enemies killed
	 GameData.death_list = data.death_list
	
	# Map Data
	if 'map' in data:
		GameData.map.restore(data.map)
	
		# Player data
	if 'player' in data:
		var start_pos = Vector2(data.player.x, data.player.y)
		spawn_player(start_pos)
		GameData.player.restore(data.player)
	
	# set Darkness
	if GameData.getting_dimmer == 1:
		GameData.player.get_node("Torch").restore_game_darkness()
	if GameData.getting_dimmer == 2:
		GameData.player.get_node("Torch").total_darkness()
	
	# Add status effects and messages
	var st_message = get_node('/root/Game/frame/right/StatusMessage')
	if GameData.player.fighter.has_status_effect('poisoned'):
		GameData.player.get_node('Glyph').add_color_override("default_color", Color(0,1,0,1))
		st_message.set_text("Poisoned")
	if GameData.player.fighter.has_status_effect('paralysed'):
		GameData.player.get_node('Glyph').add_color_override("default_color", Color(0.75, 0.75, 0.75, 1))
		st_message.set_text("Paralysed")
	if GameData.player.fighter.has_status_effect('stealth'):
		GameData.original_player_radius = GameData.player_radius
		GameData.player_radius = 1
		st_message.set_text("Stealthy")
	
	# Object data
	if 'objects' in data:
		for entry in data.objects:
			var ob = restore_object(entry)
			var pos = Vector2(entry.x,entry.y)
			ob.spawn(GameData.map,pos)
	
	# Inventory data
	if 'inventory' in data:
		for entry in data.inventory:
			var ob = restore_object(entry)
			ob.pickup()
			re_equip_weapons_armour(entry, ob)
			# Clear status messages
			GameData.clear_messages()
			# Welcome message
			GameData.broadcast("\n\nWelcome back "+GameData.player.name+"...")
	# close file and return status
	file.close()
	# build a Pathfinding map
	PathGen.build_map(GameData.MAP_SIZE,DungeonGen.get_floor_cells())
	return opened

func restore_object(data):
	var ob = load(data.filename).instance()
	ob = ob.restore(data)
	return ob

func spawn_player(cell):
	GameData.map.spawn_object('Player/Player',DungeonGen.start_pos)
	var ob = GameData.player

	ob.connect("name_changed", GameData.game.playerinfo, "name_changed")
	ob.emit_signal("name_changed", ob.name)
	ob.fighter.connect("race_changed", GameData.game.playerinfo, "race_changed")
	ob.fighter.emit_signal("race_changed", ob.fighter.race)
	ob.fighter.connect("attack_changed", GameData.game.playerinfo, "attack_changed")
	ob.fighter.emit_signal("attack_changed",ob.fighter.attack)
	ob.fighter.connect("defence_changed", GameData.game.playerinfo, "defence_changed")
	ob.fighter.emit_signal("defence_changed",ob.fighter.defence)
	ob.fighter.connect("hp_changed", GameData.game.playerinfo, "hp_changed")
	ob.fighter.emit_signal("hp_changed",ob.fighter.hp, ob.fighter.max_hp)
	ob.fighter.connect("xp_changed", GameData.game.playerinfo, "xp_changed")
	ob.fighter.emit_signal("xp_changed",ob.fighter.xp)
	ob.fighter.connect("character_level_changed", GameData.game.playerinfo, "character_level_changed")
	ob.fighter.emit_signal("character_level_changed",ob.fighter.character_level)

func pos_in_map(pos):
	var rect = Rect2(pos,Vector2(1,1))
	return viewport_panel.get_rect().intersects(rect)

func _ready():
	get_tree().set_auto_accept_quit(false)
	GameData.game = self
	messagebox.set_scroll_follow(true)
	set_process_input(true)
	if GameData.load_continue_newlvl == "continue":
		restore_game()
	elif GameData.load_continue_newlvl == "newlvl":
		load_new_level()
	else:
		new_game()


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		var saved = save_game()
		if saved != OK:
			print('SAVE GAME RETURNED ERROR: '+str(saved))
		get_tree().quit()


func _input( ev ):
	if ev.type == InputEvent.MOUSE_MOTION:
		self.is_mouse_in_map = pos_in_map(ev.pos)
		var new_mouse_cell = GameData.map.world_to_map(GameData.map.get_local_mouse_pos())
		if new_mouse_cell != mouse_cell:
			self.mouse_cell = new_mouse_cell
	if ev.type == InputEvent.MOUSE_BUTTON and ev.pressed:
		if self.is_mouse_in_map:
			if ev.button_index == BUTTON_LEFT:
				emit_signal('map_clicked', self.mouse_cell)
		if ev.button_index == BUTTON_RIGHT:
			emit_signal('map_clicked', null)

func _set_is_mouse_in_map(what):
	is_mouse_in_map = what
	GameData.map.set_cursor_hidden(!is_mouse_in_map)

func _set_mouse_cell(what):
	mouse_cell = what
	GameData.map.set_cursor()

func _on_IncreaseHP_pressed():
	# Increase max health 10%
	var newmax = floor((GameData.player.fighter.max_hp/100.0)*10) + GameData.player.fighter.max_hp
	GameData.player.fighter.max_hp = newmax
	get_node('LevelUp').hide()
	get_tree().set_pause(false)

func _on_IncreaseATT_pressed():
	GameData.player.fighter.attack += GameData.player.fighter.character_level
	get_node('LevelUp').hide()
	get_tree().set_pause(false)

func _on_IncreaseDEF_pressed():
	GameData.player.fighter.defence += GameData.player.fighter.character_level
	get_node('LevelUp').hide()
	get_tree().set_pause(false)

func _on_IncreaseATTDEF_pressed():
	var boost = floor(GameData.player.fighter.character_level/2)
	GameData.player.fighter.attack += boost
	GameData.player.fighter.defence += boost
	get_node('LevelUp').hide()
	get_tree().set_pause(false)

# Keep mouse pointer on map whilst casting spell / throwing item
func _on_map_mouse_exit():
	if GameData.in_use == true:
		get_viewport().warp_mouse(get_viewport().get_rect().size/2.0)
		GameData.broadcast("Click the map to confirm, RMB to cancel")
	else:
		pass