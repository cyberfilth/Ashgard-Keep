# rock_thrower_goblin_AI

extends Node

onready var owner = get_parent()
var random_location = Vector2(0,0) # somewhere to wander
var has_random_location = false # has somewhere to wander
var ready_to_zap = false
var zap_timer = 3 # timer before zapping the player
var throw_range = 4

func _ready():
	owner.ai = self

func take_turn():
	if owner.fighter.has_status_effect('confused'):
		confused_wander()
	var target = GameData.player
	var distance = owner.distance_to(target.get_map_pos())
	# If not in range of the player
	if distance > GameData.player_radius:
		if has_random_location == false:
			choose_random_location() # Select location
			owner.step_to(random_location) # Move to location
			check_if_at_location() # check if arrived, set new location if needed
		else:
			owner.step_to(random_location) # move to location
			check_if_at_location() # check if arrived, set new location if needed
	# If in range of player
	elif distance <= GameData.player_radius:
		if distance <= 1:
			owner.fighter.fight(target)
		elif distance >= 3: # rock throwing distance
			throw_rock()
		else:
			confused_wander()

func choose_random_location():
	var x = GameData.roll(owner.get_map_pos().x+5, owner.get_map_pos().x-5)
	var y = GameData.roll(owner.get_map_pos().y+5, owner.get_map_pos().y-5)
	var pos = Vector2(x,y)
		# stops location being placed in a wall
	while GameData.map.is_cell_blocked(pos):
		x = GameData.roll(owner.get_map_pos().x+5, owner.get_map_pos().x-5)
		y = GameData.roll(owner.get_map_pos().y+5, owner.get_map_pos().y-5)
		pos = Vector2(x,y)
	random_location = pos
	has_random_location = true

func check_if_at_location():
	if owner.get_map_pos() == random_location:
		has_random_location = false

func throw_rock():
	if ready_to_zap == false:
		ready_to_zap = true
		return
	else:
		if zap_timer > 1:
			zap_timer -=1
			return
		else:
			zap_player()

func stop_glowing():
	ready_to_zap = false
	zap_timer = 3

func zap_player():
	var target = GameData.player
	var cell = target.get_map_pos()
	var distance = owner.distance_to(cell)
	# create a rock and throw it
	print("Dropping a rock")
	GameData.map.spawn_rock(GameData.map.map_to_world(owner.get_map_pos()))
	#obj = obj[0]
	#obj.item.npc_throw(owner.get_map_pos())
	
#	var drain_amount = GameData.roll(2, 10)
#	if distance <= GameData.player_radius:
#		GameData.map.spawn_vampiric_drain_fx()
#		GameData.player.fighter.take_damage('Vampiric drain', drain_amount)
#		owner.fighter.hp+=drain_amount
#		stop_glowing()
#	else:
	stop_glowing()

func confused_wander():
	var UP = randi()%2
	var DOWN = randi()%2
	var LEFT = randi()%2
	var RIGHT = randi()%2
	var dir = Vector2( RIGHT-LEFT, DOWN-UP )
	owner.step(dir)