# rabid_wolf_AI

extends Node

onready var object_owner = get_parent()

var warning_message = ['The wolf begins to growl',\
	'The wolf bares its teeth then launches itself at you',\
	'The wolf howls with rage']

func _ready():
	object_owner.ai = self

func take_turn():
	if object_owner.fighter.has_status_effect('confused'):
		wander()
	var target = GameData.player
	var distance = object_owner.distance_to(target.get_map_position())
	var random_growling = randi()%3
	if distance <= (GameData.player_radius - 2):
		if distance <= 1:
			object_owner.fighter.fight(target)		
		if random_growling == 1:
			flavour_text()
		else:
			object_owner.step_to(target.get_map_position())
	else:
		wander()

func flavour_text():
	var message = warning_message[GameData.roll(0, warning_message.size()-1)]
	GameData.broadcast(message, GameData.COLOUR_TEAL)

func wander():
	var UP = randi()%2
	var DOWN = randi()%2
	var LEFT = randi()%2
	var RIGHT = randi()%2
	var dir = Vector2( RIGHT-LEFT, DOWN-UP )
	object_owner.step(dir)
