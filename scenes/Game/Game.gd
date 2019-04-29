extends Container

signal map_clicked(cell)

onready var messagebox = get_node('frame/left/MessageBox')
onready var playerinfo = get_node('frame/right/PlayerInfo')
onready var viewport_panel = get_node('frame/left/map')

onready var inventory_menu = get_node('InventoryMenu')

var is_mouse_in_map = false setget _set_is_mouse_in_map
var mouse_cell = Vector2() setget _set_mouse_cell

func spawn_player():
	RPG.map.spawn_object('Player/Player',DungeonGen.start_pos)
	var ob = RPG.player
	
	ob.connect("name_changed", RPG.game.playerinfo, "name_changed")
	ob.emit_signal("name_changed", ob.name)
	ob.connect("race_changed", RPG.game.playerinfo, "race_changed")
	ob.emit_signal("race_changed", ob.race)
	ob.fighter.connect("attack_changed", RPG.game.playerinfo, "attack_changed")
	ob.fighter.emit_signal("attack_changed",ob.fighter.attack)
	ob.fighter.connect("defence_changed", RPG.game.playerinfo, "defence_changed")
	ob.fighter.emit_signal("defence_changed",ob.fighter.defence)
	ob.fighter.connect("hp_changed", RPG.game.playerinfo, "hp_changed")
	ob.fighter.emit_signal("hp_changed",ob.fighter.hp, ob.fighter.max_hp)


func _ready():
	RPG.game = self
	messagebox.set_scroll_follow(true)
	spawn_player()
	set_process_input(true)

func pos_in_map(pos):
	var rect = Rect2(pos,Vector2(1,1))
	return viewport_panel.get_rect().intersects(rect)

func _input( ev ):
	if ev.type == InputEvent.MOUSE_MOTION:
		self.is_mouse_in_map = pos_in_map(ev.pos)
		var new_mouse_cell = RPG.map.world_to_map(RPG.map.get_local_mouse_pos())
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
	RPG.map.set_cursor_hidden(!is_mouse_in_map)

func _set_mouse_cell(what):
	mouse_cell = what
	RPG.map.set_cursor()
