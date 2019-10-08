extends Node2D

# list of things the orc warrior may be carrying
var items = ["res://objects/weapons/orc_blade.tscn",\
			"res://objects/weapons/spiked_club.tscn",\
			"res://objects/armour/fine_leather_armour.tscn"]

func _ready():
	pass

func drop_item():
	var choice = items[GameData.roll(0, items.size()-1)]
	return choice