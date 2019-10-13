extends Node

onready var parent = get_parent()

# Confused
func random_step():
	var UP = randi()%2
	var DOWN = randi()%2
	var LEFT = randi()%2
	var RIGHT = randi()%2
	var dir = Vector2( RIGHT-LEFT, DOWN-UP )
	parent.step(dir)


# GRAB action
func Grab():
	var items = []
	for ob in GameData.map.get_objects_in_cell(parent.get_map_position()):
		if ob.item:
			items.append(ob)
	if not items.empty():
		var result = items[0].item.pickup()
		if result == OK:
			parent.emit_signal('object_acted')

# DROP action
func Drop():
	if GameData.in_use == true:
		GameData.broadcast("Click the map to confirm, RMB to cancel")
		return
	GameData.inventory.call_drop_menu()
	var items = yield(GameData.inventory_menu, 'items_selected')
	if items.empty():
		GameData.broadcast("action cancelled")
	else:
		for obj in items:
			obj.item.drop()
			parent.emit_signal('object_acted')

#THROW action
func Throw():
	if GameData.in_use == true:
		GameData.broadcast("Click the map to confirm, RMB to cancel")
		return
	GameData.inventory.call_throw_menu()
	var obj = yield(GameData.inventory_menu, 'items_selected')
	if obj.empty():
		GameData.broadcast("action cancelled")
	else:
		obj = obj[0]
		obj.item.throw(1)

# WAIT action
func Wait():
	parent.emit_signal('object_acted')

func _ready():
	print("Controller ready")
	GameData.player = parent
	parent.connect("object_moved", GameData.map.get_node('Fogmap'), '_on_player_pos_changed')
	parent.connect("object_acted", GameData.map, "_on_player_acted")
	set_process_input(true)
	set_process(true)


func _process(delta):
	handle_input()

func handle_input():
	var N = Input.is_action_pressed('step_N')
	var NE = Input.is_action_pressed('step_NE')
	var E = Input.is_action_pressed('step_E')
	var SE = Input.is_action_pressed('step_SE')
	var S = Input.is_action_pressed('step_S')
	var SW = Input.is_action_pressed('step_SW')
	var W = Input.is_action_pressed('step_W')
	var NW = Input.is_action_pressed('step_NW')
	var WAIT = Input.is_action_pressed('step_WAIT')
	
	var GRAB = Input.is_action_pressed('act_GRAB')
	var DROP = Input.is_action_pressed('act_DROP')
	var THROW = Input.is_action_pressed('act_THROW')
	# Status effects
	if parent.fighter.has_status_effect('confused'):
		if N || NE || E || SE || S || SW || W || NW || WAIT:
			random_step()
			return
	if parent.fighter.has_status_effect('paralysed') || parent.fighter.has_status_effect('stuck'):
		if N || NE || E || SE || S || SW || W || NW:
			Wait()
			return
	
	if N:
		parent.step(Vector2(0,-1))
	if NE:
		parent.step(Vector2(1,-1))
	if E:
		parent.step(Vector2(1,0))
	if SE:
		parent.step(Vector2(1,1))
	if S:
		parent.step(Vector2(0,1))
	if SW:
		parent.step(Vector2(-1,1))
	if W:
		parent.step(Vector2(-1,0))
	if NW:
		parent.step(Vector2(-1,-1))
	
	if WAIT:
		Wait()
	if GRAB:
		Grab()
	if DROP:
		Drop()
	if THROW:
		Throw()
