# ghoul_rat_AI

extends Node

onready var object_owner = get_parent()

func _ready():
	object_owner.ai = self

func take_turn():
	if object_owner.fighter.has_status_effect('confused'):
		wander()
	if object_owner.fighter.has_status_effect('paralysed') || object_owner.fighter.has_status_effect('stuck'):
		wait()
	var target = GameData.player
	var distance = object_owner.distance_to(target.get_map_position())
	if distance <= (GameData.player_radius - 2):
		if distance <= 1:
			object_owner.fighter.fight(target)
		else:
			object_owner.step_to(target.get_map_position())
	else:
		wander()

func wander():
	var UP = randi()%2
	var DOWN = randi()%2
	var LEFT = randi()%2
	var RIGHT = randi()%2
	var dir = Vector2( RIGHT-LEFT, DOWN-UP )
	object_owner.step(dir)

func wait():
	print("waiting")
	object_owner.emit_signal('object_acted')
