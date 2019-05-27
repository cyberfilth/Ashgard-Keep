extends Node

export(int) var dice = 0
export(int) var adds = 0
export(bool) var equipped = false


func equip(weapon_name, dice, adds):
	GameData.player.fighter.weapon_equipped = true
	GameData.player.fighter.weapon_dice = dice
	GameData.player.fighter.weapon_adds = adds
	equipped == true
	GameData.broadcast(weapon_name + " has been equipped, +" + str(dice)+"D"+str(adds) + " to Attack")