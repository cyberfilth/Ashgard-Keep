# blue_fungus_AI

extends Node

onready var parent = get_parent()

func _ready():
	parent.ai = self

func take_turn():
	var target = GameData.player
	var distance = parent.distance_to(target.get_map_position())
	if distance <= 1:
		parent.fighter.fight(target)
