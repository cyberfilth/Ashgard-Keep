extends Node

onready var owner = get_parent()

export(String) var use_function = ''
export(bool) var stackable = false
export(bool) var indestructible = false

var inventory_slot

func use():
	if use_function.empty():
		RPG.broadcast("The " +owner.name+ " cannot be used", RPG.COLOR_DARK_GREY)
		return
	if has_method(use_function):
		var result = call(use_function)
		if result != "OK":
			RPG.broadcast(result,RPG.COLOR_DARK_GREY)
			return
		if not indestructible:
			owner.kill()

func pickup():
	RPG.inventory.add_to_inventory(owner)

func drop():
	assert inventory_slot != null
	RPG.inventory.remove_from_inventory(inventory_slot,owner)

func _ready():
	owner.item = self

# USE FUNCTIONS
func heal_player():
	var amount = 5
	if RPG.player.fighter.is_hp_full():
		return "You're already at full health"
	RPG.player.fighter.heal_damage(owner, amount)
	return "OK"