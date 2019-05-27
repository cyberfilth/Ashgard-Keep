extends Node

export(int) var dice = 0
export(int) var adds = 0
export(String) var description = " "
export(bool) var equipped = false


func equip(weapon_name, dice, adds):
	var fighter = GameData.player.fighter
	fighter.weapon_equipped = true
	fighter.weapon_dice = dice
	fighter.weapon_adds = adds
	equipped == true
	GameData.broadcast(weapon_name + " has been equipped, +" + str(dice)+"D"+str(adds) + " to Attack")