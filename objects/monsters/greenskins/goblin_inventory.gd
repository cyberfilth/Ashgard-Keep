extends Node2D

# list of things the goblin may be carrying
var items = ["res://objects/weapons/goblin_dagger.tscn",\
			"res://objects/weapons/crude_dagger.tscn"]

func _ready():
	pass

func drop_item():
	var choice = items[GameData.roll(0, items.size()-1)]
	return choice