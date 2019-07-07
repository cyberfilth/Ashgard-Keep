extends Node2D

# list of things the necromancer may be carrying
var items = ["res://objects/items/HealthPotion.tscn", "res://objects/items/Scroll_LightningBolt.tscn"]


func _ready():
	pass

func drop_item():
	var choice = items[GameData.roll(0, items.size()-1)]
	return choice