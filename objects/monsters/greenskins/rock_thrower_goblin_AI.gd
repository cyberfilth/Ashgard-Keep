# rock_thrower_goblin_AI

extends Node

onready var parent = get_parent()
var random_location = Vector2(0,0) # somewhere to wander
var has_random_location = false # has somewhere to wander
var ready_to_throw = false
var throw_timer = 3 # timer before throwing the projectile
var number_of_rocks = 3

func _ready():
	parent.ai = self

func take_turn():
	if parent.fighter.has_status_effect('confused'):
		confused_wander()
	var target = GameData.player
	var distance = parent.distance_to(target.get_map_position())
	# If not in range of the player
	if distance > GameData.player_radius:
		if has_random_location == false:
			choose_random_location() # Select location
			parent.step_to(random_location) # Move to location
			check_if_at_location() # check if arrived, set new location if needed
		else:
			parent.step_to(random_location) # move to location
			check_if_at_location() # check if arrived, set new location if needed
	# If in range of player
	elif distance <= GameData.player_radius:
		if distance <= 1:
			parent.fighter.fight(target)
		elif distance >= 3: # rock throwing distance
			if number_of_rocks > 0: # check if there are still rocks to throw
				prepare_to_throw_rock()
			else: # Attack player if out of rocks
				parent.step_to(target.get_map_position())
		else:
			confused_wander()

func choose_random_location():
	var x = min(GameData.roll(parent.get_map_position().x+5, parent.get_map_position().x-5), (GameData.MAP_SIZE.x-1))
	var y = min(GameData.roll(parent.get_map_position().y+5, parent.get_map_position().y-5), (GameData.MAP_SIZE.y-1))
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

func prepare_to_throw_rock():
	if ready_to_throw == false:
		ready_to_throw = true
		return
	else:
		if throw_timer > 1:
			throw_timer -=1
			return
		else:
			throw_rock_at_player()

func wind_down():
	ready_to_throw = false
	throw_timer = 3

# create a rock and throw it
func throw_rock_at_player():
	GameData.map.spawn_rock("Goblin", GameData.map.map_to_world(parent.get_map_position()))
	number_of_rocks -= 1
	wind_down()

func confused_wander():
	var UP = randi()%2
	var DOWN = randi()%2
	var LEFT = randi()%2
	var RIGHT = randi()%2
	var dir = Vector2( RIGHT-LEFT, DOWN-UP )
	parent.step(dir)
