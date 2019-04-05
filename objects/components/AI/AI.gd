extends Node

onready var owner = get_parent()

func _ready():
	owner.ai = self
	
func take_turn():
	var target = RPG.player
	var distance = owner.distance_to(target.get_map_pos())
	if distance <= RPG.TORCH_RADIUS:
		if distance <= 1:
			owner.fighter.fight(target)
		else:
			owner.step_to(target.get_map_pos())