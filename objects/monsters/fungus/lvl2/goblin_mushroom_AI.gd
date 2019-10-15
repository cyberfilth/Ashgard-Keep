# goblin_mushroom_AI

extends Node

onready var object_owner = get_parent()
var seen = false # Changes to true when the Goblin first sees the player
var utterances = ['Help me! It\'s growing inside meeee!', 'Aaah, it\'s taking over my mind!',\
'NOOooooooo! I\'m changing....', 'The mushrooms! Don\'t let them touch yoooooo!']

func _ready():
	object_owner.ai = self

func take_turn():
	var target = GameData.player
	var distance = object_owner.distance_to(target.get_map_position())
	if distance <= (GameData.player_radius - 2):
		if seen == false:
			grunt()
		else:
			transform()
			self.get_parent().get_node("Fighter").die()

func grunt():
	var message = utterances[GameData.roll(0, utterances.size()-1)]
	GameData.broadcast("The Goblin screams, \""+message+"\"")
	seen = true

func transform():
	var spore_cloud = load("res://graphics/particles/spore_cloud.tscn")
	var scene_instance = spore_cloud.instance()
	scene_instance.set_name("spore_cloud")
	GameData.map.add_child(scene_instance)
	scene_instance.set_position(GameData.map.map_to_world(object_owner.get_map_position()))
	GameData.map.spawn_mushroom_goblin(GameData.map.map_to_world(object_owner.get_map_position()))
