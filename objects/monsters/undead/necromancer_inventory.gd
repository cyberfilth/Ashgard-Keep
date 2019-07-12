extends Node2D

# list of things the necromancer may be carrying
var items = ["res://objects/items/books/Book_necro1.tscn",\
			"res://objects/weapons/bone_dagger.tscn",\
			"res://objects/items/StealthPotion.tscn"]


func _ready():
	pass

func drop_item():
	var choice = items[GameData.roll(0, items.size()-1)]
	return choice