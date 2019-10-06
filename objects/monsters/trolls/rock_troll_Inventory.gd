extends Node2D

# list of things the rock troll may be carrying
var items = ["res://objects/weapons/club.tscn"]

func _ready():
	pass

func drop_item():
	var choice = items[GameData.roll(0, items.size()-1)]
	return choice