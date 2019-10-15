# lvl3 mushroom_person_AI

extends Node

onready var object_owner = get_parent()
var seen = false # Changes to true when the mushroom first sees the player
var utterances = ['Ggg-Garrk', 'Eaten.... kahhh', 'NOOooooooo!', 'MMM-Matango....', 'Cannot... escape..']

func _ready():
	object_owner.ai = self

func take_turn():
	if object_owner.fighter.has_status_effect('confused'):
		wander()
	
	var target = GameData.player
	var distance = object_owner.distance_to(target.get_map_position())
	if distance <= (GameData.player_radius - 1):
		if seen == false:
			grunt()
		if distance <= 1:
			object_owner.fighter.fight(target)
		else:
			# flip a coin to see if mushroom gets
			# distracted whilst chasing player
			var attention = randi()%2
			if attention == 1:
				object_owner.step_to(target.get_map_position())

func grunt():
	var chance_to_grunt = randi()%4
	if chance_to_grunt == 1:
		var message = utterances[GameData.roll(0, utterances.size()-1)]
		GameData.broadcast("Mushroom person moans \""+message+"\"")
	seen = true
