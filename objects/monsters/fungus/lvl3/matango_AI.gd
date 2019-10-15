# matango_AI

extends Node

onready var object_owner = get_parent()
var random_location = Vector2(0,0) # somewhere to wander
var has_random_location = false # has somewhere to wander

func _ready():
	object_owner.ai = self

func take_turn():
	if object_owner.fighter.has_status_effect('confused'):
		confused_wander()
	var target = GameData.player
	var distance = object_owner.distance_to(target.get_map_position())
	# If not in range of the player
	if distance > GameData.player_radius:
		if has_random_location == false:
			choose_random_location() # Select location
			object_owner.step_to(random_location) # Move to location
			check_if_at_location() # check if arrived, set new location if needed
		else:
			object_owner.step_to(random_location) # move to location
			check_if_at_location() # check if arrived, set new location if needed
	# If in range of player
	elif distance <= GameData.player_radius:
		if distance <= 1:
			object_owner.fighter.fight(target)
		else:
			object_owner.step_to(target.get_map_position())
	else:
		confused_wander()

func confused_wander():
	var UP = randi()%2
	var DOWN = randi()%2
	var LEFT = randi()%2
	var RIGHT = randi()%2
	var dir = Vector2( RIGHT-LEFT, DOWN-UP )
	object_owner.step(dir)

func choose_random_location():
	var x = GameData.roll(object_owner.get_map_position().x+5, object_owner.get_map_position().x-5)
	var y = GameData.roll(object_owner.get_map_position().y+5, object_owner.get_map_position().y-5)
	var pos = Vector2(x,y)
		# stops location being placed in a wall
	while GameData.map.is_cell_blocked(pos):
		x = min(GameData.roll(object_owner.get_map_position().x+5, object_owner.get_map_position().x-5), (GameData.MAP_SIZE.x-1))
		y = min(GameData.roll(object_owner.get_map_position().y+5, object_owner.get_map_position().y-5), (GameData.MAP_SIZE.y-1))
		pos = Vector2(x,y)
	random_location = pos
	has_random_location = true
