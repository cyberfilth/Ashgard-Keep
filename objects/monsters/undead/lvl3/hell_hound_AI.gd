# hell_hound_AI

extends Node

onready var owner = get_parent()

var warning_message = ['The Hell Hound begins to growl',\
	'Hell Hound bares its teeth then launches itself at you',\
	'The Hell Hound howls with rage']

func _ready():
	owner.ai = self

func take_turn():
	if owner.fighter.has_status_effect('confused'):
		wander()
	var target = GameData.player
	var distance = owner.distance_to(target.get_map_position())
	var random_growling = randi()%3
	if distance <= (GameData.player_radius - 2):
		if distance <= 1:
			owner.fighter.fight(target)		
		if random_growling == 1:
			flavour_text()
		else:
			owner.step_to(target.get_map_position())
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
	owner.step(dir)

