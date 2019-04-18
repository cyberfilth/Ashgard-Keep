extends Node

signal used(result)
onready var owner = get_parent()

export(String,\
 'heal_player', 'damage_nearest', 'confuse_target'\
) var use_function = ''
export(int) var param1 = 0
export(bool) var stackable = false
export(bool) var indestructible = false

var inventory_slot

func use():
	if use_function.empty():
		RPG.broadcast("The " +owner.name+ " cannot be used", RPG.COLOR_DARK_GREY)
		return
	if has_method(use_function):
		call(use_function)

func pickup():
	RPG.inventory.add_to_inventory(owner)

func drop():
	assert inventory_slot != null
	RPG.inventory.remove_from_inventory(inventory_slot,owner)

func _ready():
	owner.item = self

# USE FUNCTIONS
func heal_player():
	var amount = self.param1
	if RPG.player.fighter.is_hp_full():
		emit_signal('used', "You're already at full health")
	RPG.player.fighter.heal_damage(owner, amount)
	emit_signal('used', "OK")

func damage_nearest():
	var amount = self.param1
	var target = RPG.map.get_nearest_visible_actor()
	if not target:
		emit_signal('used', "No targets in sight")
	target.fighter.take_damage("Lightning Strike", amount)
	emit_signal('used', "OK")

func confuse_target():
	var target = null
	# instruct the player to choose a target or cancel
	RPG.broadcast("Use your mouse to target an enemy.  LMB to select a target, RMB to cancel")
	# yield for map clicking feedback
	var callback = yield(RPG.game, 'map_clicked')
	
	# callback==null = RMB to cancel
	if callback==null:
		emit_signal('used', "action cancelled")
		return
	# cell clicked
	else:
		# assign potential target
		target = RPG.map.get_actor_in_cell(callback)
	# if no actor in cell
	if not target:
		emit_signal('used', "no target there")
		return
	# if clicking yourself
	elif target == RPG.player:
		emit_signal('used', "you don't want to confuse yourself!")
		return
	
	# found valid target
	RPG.broadcast(target.get_display_name() + " looks very confused!", RPG.COLOR_BROWN)
	target.fighter.apply_status_effect('confused',param1)
	emit_signal('used', "OK")