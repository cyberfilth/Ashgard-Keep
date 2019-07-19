# Portal script

extends Node

onready var owner = get_parent()

func _ready():
	owner.ai = self

func take_turn():
	var target = GameData.player
	var distance = owner.distance_to(target.get_map_pos())
	if distance <= 1:
		owner.fighter.fight(target)

# Checks before entering portal
func enter_portal():
	pass

# loadup the next floor of the Keep
func load_new_level():
	# increment keep level
	# update ui
	#get_node('/root/Game/frame/right/StatusMessage').set_text("")
	GameData.player_view = 5
	GameData.getting_dimmer = 0
	GameData.torch_timer = 0
	GameData.colr = 0
	GameData.colg = 0
	GameData.colb = 0
	# reset torch settings
	
	
	# light circle
	
	
	GameData.load_continue = "load"
	get_tree().change_scene('res://scenes/TitleMenu/LoadingScreen.tscn')