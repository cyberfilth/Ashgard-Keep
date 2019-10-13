# ratling_AI

extends Node

onready var parent = get_parent()
var random_location = Vector2(0,0) # somewhere to wander
var has_random_location = false # has somewhere to wander

func _ready():
	parent.ai = self

func take_turn():
	if parent.fighter.has_status_effect('confused'):
		wander()
	var target = GameData.player
	var distance = parent.distance_to(target.get_map_position())
	if parent.fighter.hp <= 9 && distance < 2:
		if has_random_location == false:
			choose_random_location() # Select location
			parent.step_to(random_location) # Move to location
			check_if_at_location() # check if arrived, set new location if needed
		else:
			parent.step_to(random_location) # move to location
			check_if_at_location() # check if arrived, set new location if needed
	if distance <= (GameData.player_radius - 2):
		if distance <= 1:
			parent.fighter.fight(target)
		else:
			parent.step_to(target.get_map_position())

func wander():
	var UP = randi()%2
	var DOWN = randi()%2
	var LEFT = randi()%2
	var RIGHT = randi()%2
	var dir = Vector2( RIGHT-LEFT, DOWN-UP )
	parent.step(dir)

func choose_random_location():
	var x = GameData.roll(parent.get_map_position().x+5, parent.get_map_position().x-5)
	var y = GameData.roll(parent.get_map_position().y+5, parent.get_map_position().y-5)
	var pos = Vector2(x,y)
		# stops location being placed in a wall
	while GameData.map.is_cell_blocked(pos):
		x = min(GameData.roll(parent.get_map_position().x+5, parent.get_map_position().x-5), (GameData.MAP_SIZE.x-1))
		y = min(GameData.roll(parent.get_map_position().y+5, parent.get_map_position().y-5), (GameData.MAP_SIZE.y-1))
		pos = Vector2(x,y)
	random_location = pos
	has_random_location = true

func check_if_at_location():
	if parent.get_map_position() == random_location:
		has_random_location = false
