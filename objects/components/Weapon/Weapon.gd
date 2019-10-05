extends Node

export(int) var dice = 0
export(int) var adds = 0
export(String) var description = " "
export(String, "sharp", "blunt") var type = "sharp"
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

func break_weapon(weapon_name, dice, adds):
	var fighter = GameData.player.fighter
	fighter.weapon_equipped = false
	fighter.weapon_dice -= dice
	fighter.weapon_adds -= adds
		## Update GUI ##
	var equipped_weapon = get_node('/root/Game/frame/right/Activity/box/weaponName')
	var weapon_description = get_node('/root/Game/frame/right/Activity/box/weaponDescription')
	equipped_weapon.set_text("No weapon equipped")
	weapon_description.set_text(" ")
	GameData.weapon_slot.remove_contents(GameData.weapon_in_use)
	GameData.weapon_slot.show_unequipped_weapon()
	GameData.player.get_node("Camera").shake(0.3, 15)
	GameData.weapon_in_use = false
	GameData.weapon_type = ""
	GameData.weapon_slot = null
	GameData.weapon_name = ""
	GameData.broadcast("Your weapon shatters!", GameData.COLOUR_YELLOW)