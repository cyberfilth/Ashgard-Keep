extends "res://objects/components/Fighter/Fighter.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func broadcast_damage_taken(from, amount):
	var m = str(amount)
	var color = GameData.COLOUR_TEAL
	if owner == GameData.player:
		color = GameData.COLOUR_RED
	GameData.broadcast(from+ " bites " +owner.get_display_name()+ " for " +m+ " damage",color)