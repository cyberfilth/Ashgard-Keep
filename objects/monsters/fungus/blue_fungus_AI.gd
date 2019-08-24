# blue_fungus_AI

extends Node

onready var owner = get_parent()

func _ready():
	owner.ai = self

func take_turn():
	var target = GameData.player
	var distance = owner.distance_to(target.get_map_pos())
	if distance <= 1:
		owner.fighter.fight(target)