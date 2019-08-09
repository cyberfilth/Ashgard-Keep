# patchwork_golem_AI

extends Node

onready var owner = get_parent()
var seen = false # Changes to true when the golem first sees the player
var utterances = ['Ugh!', 'F-Friend?', 'Raaaar', 'You.. belong... Dead!', 'Uugh!']

func _ready():
	owner.ai = self

func take_turn():
	if owner.fighter.has_status_effect('confused'):
		wander()
	
	var target = GameData.player
	var distance = owner.distance_to(target.get_map_pos())
	if distance <= (GameData.player_radius - 3):
		if seen == false:
			grunt()
		if distance <= 1:
			owner.fighter.fight(target)
		else:
			# flip a coin to see if golem gets
			# distracted whilst chasing player
			var attention = randi()%2
			if attention == 1:
				owner.step_to(target.get_map_pos())

func grunt():
	var chance_to_grunt = randi()%4
	if chance_to_grunt == 1:
		var message = utterances[GameData.roll(0, utterances.size()-1)]
		GameData.broadcast(message, GameData.COLOUR_YELLOW)
	seen = true

func wander():
	var UP = randi()%2
	var DOWN = randi()%2
	var LEFT = randi()%2
	var RIGHT = randi()%2
	var dir = Vector2( RIGHT-LEFT, DOWN-UP )
	owner.step(dir)
