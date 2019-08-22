extends Node2D

# list of things the lvl3 vampire may be carrying
var items = ["res://objects/weapons/blood_drinker.tscn",\
			"res://objects/weapons/shard_sword.tscn",\
			"res://objects/items/StealthPotion.tscn"]

func _ready():
	pass

func drop_item():
	var choice = items[GameData.roll(0, items.size()-1)]
	return choice