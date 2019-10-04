extends Node

export(int) var dice = 0
export(int) var adds = 0
export(String) var description = " "
export(String) var type = "sharp"
# Any special attack modifiers go here
export(String, "attack", "hp_drain") var special_attack = "attack"

func equip(weapon_name, dice, adds):
	var fighter = GameData.player.fighter
	fighter.weapon_equipped = true
	fighter.weapon_dice = dice
	fighter.weapon_adds = adds
	fighter.weapon_modifier = special_attack
	get_parent().get_node('Item').equipped = true
	if adds !=0:
		GameData.broadcast(weapon_name + " has been equipped, adds " + str(dice)+"D+"+str(adds) + " to Attack")
	else:
		GameData.broadcast(weapon_name + " has been equipped, adds " + str(dice)+"D to Attack")

func unequip(weapon_name, dice, adds):
	var fighter = GameData.player.fighter
	fighter.weapon_equipped = false
	fighter.weapon_dice -= dice
	fighter.weapon_adds -= adds
	get_parent().get_node('Item').equipped = false
	GameData.broadcast(weapon_name + " unequipped")