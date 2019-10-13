# goblin_AI

extends Node

onready var parent = get_parent()
onready var new_name = PlotGen.npc_greenskin1

func _ready():
	parent.ai = self
	parent.get_node(".").name = new_name

func take_turn():
	if parent.fighter.has_status_effect('confused'):
		wander()
	var target = GameData.player
	var distance = parent.distance_to(target.get_map_position())
	if parent.fighter.hp <= 9 && distance < 2:
		wander()
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
