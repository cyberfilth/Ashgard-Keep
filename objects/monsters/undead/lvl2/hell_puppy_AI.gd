# hell_puppy_AI

extends Node

onready var owner = get_parent()

var warning_message = ['The demonic Hell puppy begins to growl',\
	'Hell puppy bares its teeth then launches itself at you',\
	'The Hell puppy begins wagging its tail and growling', 'The Hell puppy howls then charges towards you']

func _ready():
	owner.ai = self

func take_turn():
	if owner.fighter.has_status_effect('confused'):
		wander()
	var target = GameData.player
	var distance = owner.distance_to(target.get_map_position())
	if owner.fighter.hp <= 9 && distance < 2:
		wander()
	if distance <= (GameData.player_radius - 2):
		var random_growling = randi()%3
		if random_growling == 1:
			flavour_text()
		if distance <= 1:
			owner.fighter.fight(target)
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

