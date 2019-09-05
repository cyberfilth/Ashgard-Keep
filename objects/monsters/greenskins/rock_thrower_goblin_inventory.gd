extends Node2D

# list of things the rock thrower goblin may be carrying
var items = ["res://objects/items/Rock.tscn",\
			"res://objects/weapons/goblin_dagger.tscn"]

func _ready():
	pass

func drop_item():
	var choice = items[GameData.roll(0, items.size()-1)]
	return choice