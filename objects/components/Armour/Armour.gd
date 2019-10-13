extends Node

export(int) var armour_protection = 0
export(String) var description = " "

func equip(armour_name, armour_protection):
	var fighter = GameData.player.fighter
	fighter.armour_equipped = true
	fighter.armour_protection = armour_protection
	get_parent().get_node('Item').equipped = true
	GameData.broadcast(armour_name + " has been equipped, +" + str(armour_protection) + " to Defence")

func unequip(armour_name, armour_protection):
	var fighter = GameData.player.fighter
	fighter.armour_equipped = false
	fighter.armour_protection -= armour_protection
	get_parent().get_node('Item').equipped = false
	GameData.broadcast(armour_name + " removed")
