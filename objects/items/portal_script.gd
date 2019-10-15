# Portal script

extends Node

onready var object_owner = get_parent()

func _ready():
	object_owner.ai = self

func take_turn():
	var target = GameData.player
	var distance = object_owner.distance_to(target.get_map_position())
	if distance < 1:
		object_owner.fighter.fight(target)

# Checks before entering portal
func enter_portal():
	if GameData.player.fighter.xp < (GameData.keeplvl * 100):
		GameData.broadcast("YOU ARE NOT EXPERIENCED ENOUGH TO ENTER THIS PORTAL.\nGain more XP first.", GameData.COLOUR_YELLOW)
	else:
		load_new_level()

# loadup the next floor of the Keep
func load_new_level():
	GameData.keeplvl += 1
	# Save player info
	GameData.player_view = 5
	GameData.getting_dimmer = 0
	GameData.torch_timer = 0
	GameData.colr = 0
	GameData.colg = 0
	GameData.colb = 0
	# Save player info
	GameData.lvlname = GameData.player.object_name
	GameData.lvlcharacter_level = GameData.player.fighter.character_level
	GameData.lvlattack = GameData.player.fighter.attack
	GameData.lvldefence = GameData.player.fighter.defence
	GameData.lvlmaxhp = GameData.player.fighter.max_hp
	GameData.lvlhp = GameData.player.fighter.hp
	GameData.lvlxp = GameData.player.fighter.xp
	GameData.lvlweapon_equipped = GameData.player.fighter.weapon_equipped
	GameData.lvlarmour_equipped = GameData.player.fighter.armour_equipped
	for node in get_tree().get_nodes_in_group('inventory'):
		GameData.player_inventory.append(node.save())
	GameData.load_continue_newlvl = "newlvl"
	get_tree().change_scene('res://scenes/TitleMenu/LoadingScreen.tscn')
