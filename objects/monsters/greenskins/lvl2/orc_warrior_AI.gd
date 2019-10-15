# orc_warrior_AI

extends Node

onready var object_owner = get_parent()

func _ready():
	object_owner.ai = self

func take_turn():
	if object_owner.fighter.has_status_effect('confused'):
		wander()
	var target = GameData.player
	var distance = object_owner.distance_to(target.get_map_position())
	if object_owner.fighter.hp <= 9 && distance < 2:
		wander()
	if distance <= (GameData.player_radius - 2):
		if distance <= 1:
			object_owner.fighter.fight(target)
		else:
			object_owner.step_to(target.get_map_position())

func wander():
	var UP = randi()%2
	var DOWN = randi()%2
	var LEFT = randi()%2
	var RIGHT = randi()%2
	var dir = Vector2( RIGHT-LEFT, DOWN-UP )
	object_owner.step(dir)
