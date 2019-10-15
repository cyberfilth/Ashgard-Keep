# blue_fungus_AI

extends Node

onready var object_owner = get_parent()

func _ready():
	object_owner.ai = self

func take_turn():
	var target = GameData.player
	var distance = object_owner.distance_to(target.get_map_position())
	if distance <= 1:
		object_owner.fighter.fight(target)
