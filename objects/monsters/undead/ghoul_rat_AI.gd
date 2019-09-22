# ghoul_rat_AI

extends Node

onready var owner = get_parent()

func _ready():
	owner.ai = self

func take_turn():
	if owner.fighter.has_status_effect('confused'):
		wander()
	if owner.fighter.has_status_effect('paralysed') || owner.fighter.has_status_effect('stuck'):
		wait()
	var target = GameData.player
	var distance = owner.distance_to(target.get_map_pos())
	if distance <= (GameData.player_radius - 2):
		if distance <= 1:
			owner.fighter.fight(target)
		else:
			owner.step_to(target.get_map_pos())
	else:
		wander()

func wander():
	var UP = randi()%2
	var DOWN = randi()%2
	var LEFT = randi()%2
	var RIGHT = randi()%2
	var dir = Vector2( RIGHT-LEFT, DOWN-UP )
	owner.step(dir)

func wait():
	print("waiting")
	owner.emit_signal('object_acted')