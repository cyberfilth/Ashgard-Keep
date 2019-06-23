# necromancer_AI

extends Node

onready var owner = get_parent()
var random_location = Vector2(0,0) # somewhere to wander
var has_random_location = false # has somewhere to wander

func _ready():
	owner.ai = self

func take_turn():
	if owner.fighter.has_status_effect('confused'):
		confused_wander()
	var target = GameData.player
	var distance = owner.distance_to(target.get_map_pos())
	# If not in range of the player
	if distance > (GameData.TORCH_RADIUS - 2):
		if has_random_location == false:
			choose_random_location() # Select location
			owner.step_to(random_location) # Move to location
			check_if_at_location() # check if arrived, set new location if needed
		else:
			owner.step_to(random_location) # move to location
			check_if_at_location() # check if arrived, set new location if needed
	# If in range of player
	elif distance <= GameData.TORCH_RADIUS:
		if distance <= 1:
			owner.fighter.fight(target)
		else:
			owner.step_to(target.get_map_pos())

func confused_wander():
	var UP = randi()%2
	var DOWN = randi()%2
	var LEFT = randi()%2
	var RIGHT = randi()%2
	var dir = Vector2( RIGHT-LEFT, DOWN-UP )
	owner.step(dir)

func choose_random_location():
	var x = GameData.roll(owner.get_map_pos().x+10, owner.get_map_pos().x-10)
	var y = GameData.roll(owner.get_map_pos().y+10, owner.get_map_pos().y-10)
	var pos = Vector2(x,y)
		# stops location being placed in a wall
	while GameData.map.is_cell_blocked(pos):
		x = GameData.roll(owner.get_map_pos().x+10, owner.get_map_pos().x-10)
		y = GameData.roll(owner.get_map_pos().y+10, owner.get_map_pos().y-10)
		pos = Vector2(x,y)
	random_location = pos
	has_random_location = true

func check_if_at_location():
	if owner.get_map_pos() == random_location:
		has_random_location = false