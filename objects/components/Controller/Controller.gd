extends Node



onready var object = get_parent()

func _ready():
	RPG.player = object
	object.connect("object_moved", RPG.map.get_node('Fogmap'), '_on_player_pos_changed')
	object.connect("object_acted", RPG.map, "_on_player_acted")
	set_process_input(true)


func _input(event):
	var N = event.is_action_pressed('step_N')
	var NE = event.is_action_pressed('step_NE')
	var E = event.is_action_pressed('step_E')
	var SE = event.is_action_pressed('step_SE')
	var S = event.is_action_pressed('step_S')
	var SW = event.is_action_pressed('step_SW')
	var W = event.is_action_pressed('step_W')
	var NW = event.is_action_pressed('step_NW')
	var WAIT = event.is_action_pressed('step_WAIT')
	
	if N:
		object.step(Vector2(0,-1))
	if NE:
		object.step(Vector2(1,-1))
	if E:
		object.step(Vector2(1,0))
	if SE:
		object.step(Vector2(1,1))
	if S:
		object.step(Vector2(0,1))
	if SW:
		object.step(Vector2(-1,1))
	if W:
		object.step(Vector2(-1,0))
	if NW:
		object.step(Vector2(-1,-1))
	
	if WAIT:
		object.wait()