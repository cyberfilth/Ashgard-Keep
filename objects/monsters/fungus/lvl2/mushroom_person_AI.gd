# mushroom_person_AI

extends Node

onready var owner = get_parent()
var seen = false # Changes to true when the mushroom first sees the player
var utterances = ['J... Join us!', 'D-Die....', 'NOOooooooo!', 'MMM-Matango....', 'Run...']

func _ready():
	owner.ai = self

func take_turn():
	if owner.fighter.has_status_effect('confused'):
		wander()
	
	var target = GameData.player
	var distance = owner.distance_to(target.get_map_pos())
	if distance <= (GameData.player_radius - 1):
		if seen == false:
			grunt()
		if distance <= 1:
			owner.fighter.fight(target)
		else:
			# flip a coin to see if mushroom gets
			# distracted whilst chasing player
			var attention = randi()%2
			if attention == 1:
				owner.step_to(target.get_map_pos())

func grunt():
	var chance_to_grunt = randi()%4
	if chance_to_grunt == 1:
		var message = utterances[GameData.roll(0, utterances.size()-1)]
		GameData.broadcast("Mushroom person moans \""+message+"\"", GameData.COLOUR_YELLOW)
	seen = true