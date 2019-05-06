extends Container

signal map_clicked(cell)

onready var messagebox = get_node('frame/left/MessageBox')
onready var playerinfo = get_node('frame/right/PlayerInfo')
onready var viewport_panel = get_node('frame/left/map')

onready var inventory_menu = get_node('InventoryMenu')

var is_mouse_in_map = false setget _set_is_mouse_in_map
var mouse_cell = Vector2() setget _set_mouse_cell

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		var saved = save_game()
		if saved != OK:
			print('SAVE GAME RETURNED ERROR '+str(saved))
		get_tree().quit()

func spawn_player():
	GameData.map.spawn_object('Player/Player',DungeonGen.start_pos)
	var ob = GameData.player
	
	ob.connect("name_changed", GameData.game.playerinfo, "name_changed")
	ob.emit_signal("name_changed", ob.name)
	ob.connect("race_changed", GameData.game.playerinfo, "race_changed")
	ob.emit_signal("race_changed", ob.race)
	ob.fighter.connect("attack_changed", GameData.game.playerinfo, "attack_changed")
	ob.fighter.emit_signal("attack_changed",ob.fighter.attack)
	ob.fighter.connect("defence_changed", GameData.game.playerinfo, "defence_changed")
	ob.fighter.emit_signal("defence_changed",ob.fighter.defence)
	ob.fighter.connect("hp_changed", GameData.game.playerinfo, "hp_changed")
	ob.fighter.emit_signal("hp_changed",ob.fighter.hp, ob.fighter.max_hp)


func _ready():
	get_tree().set_auto_accept_quit(false)
	GameData.game = self
	messagebox.set_scroll_follow(true)
	spawn_player()
	set_process_input(true)

func pos_in_map(pos):
	var rect = Rect2(pos,Vector2(1,1))
	return viewport_panel.get_rect().intersects(rect)

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

# Save Game Function
func save_game():	
	# create a new file object to work with
	var file = File.new()
	var opened = file.open(GameData.SAVEGAME_PATH, File.WRITE)
	
	# Alert and return error if file can't be opened
	if not opened == OK:
		OS.alert("Unable to access file " + GameData.SAVEGAME_PATH)
		return opened

	# Gather data to save
	var data = {}
	
	# Map data: Datamap and Fogmap
	data.map = GameData.map.save()
	
	# Player object data
	data.player = GameData.player.save()
	
	# Global player data
	#data.player_data = GameData.player_data
	
	# non-player Objects group
	data.objects = []
	data.inventory = []
	for node in get_tree().get_nodes_in_group('objects'):
		if node != GameData.player:
			if node.is_in_group('world'):
				data.objects.append(node.save())
			elif node.is_in_group('inventory'):
				data.inventory.append(node.save())
		
#	# Inventory group
	#data.inventory = [] ?
	for node in get_tree().get_nodes_in_group('inventory'):
		data.inventory.append(node.save())
	
	# Store data and close file
	file.store_line(data.to_json())
	file.close()
	# Return OK if all goes well
	return opened
