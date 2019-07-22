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
	load_new_level()

# loadup the next floor of the Keep
func load_new_level():
	GameData.keeplvl += 1
	var suffix = ""
	if GameData.keeplvl == 11 || GameData.keeplvl == 12 || GameData.keeplvl == 13:
		suffix = "th"
	elif (GameData.keeplvl % 10 == 1):
		suffix = "st"
	elif (GameData.keeplvl % 10 == 2):
		suffix = "nd"
	elif (GameData.keeplvl % 10 == 3):
		suffix = "rd"
	else:
		suffix = "th"
	var keep_level = str(GameData.keeplvl)+suffix
	# update ui
	get_node('/root/Game/frame/right/PlayerInfo/frame/stats/right/labels/Location').set_text(keep_level+" floor")
	GameData.player_view = 5
	GameData.getting_dimmer = 0
	GameData.torch_timer = 0
	GameData.colr = 0
	GameData.colg = 0
	GameData.colb = 0
	# reset torch settings
	
	# light circle
		
	GameData.load_continue_newlvl = "newlvl"
	get_tree().change_scene('res://scenes/TitleMenu/LoadingScreen.tscn')
