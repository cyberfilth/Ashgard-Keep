extends Node

onready var owner = get_parent()

func _ready():
	owner.ai = self
	
func take_turn():
	if owner.fighter.has_status_effect('confused'):
		var UP = randi()%2
		var DOWN = randi()%2
		var LEFT = randi()%2
		var RIGHT = randi()%2
		var dir = Vector2( RIGHT-LEFT, DOWN-UP )
		owner.step(dir)
		return
		
	var target = RPG.player
	var distance = owner.distance_to(target.get_map_pos())
	if distance <= RPG.TORCH_RADIUS:
		if distance <= 1:
			owner.fighter.fight(target)
		else:
			owner.step_to(target.get_map_pos())
