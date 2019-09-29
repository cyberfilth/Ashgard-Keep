extends Node2D

# list of things the ratling may be carrying
var items = ["res://objects/weapons/crude_dagger.tscn",\
			"res://objects/armour/crude_leather_armour.tscn"]

func _ready():
	pass

func drop_item():
	var choice = items[GameData.roll(0, items.size()-1)]
	return choice