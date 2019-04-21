extends Node

signal used(result)
onready var owner = get_parent()

export(String,\
 'heal_player', 'damage_nearest',\
 'confuse_target', 'blast_cell'\
) var use_function = ''

export(String, MULTILINE) var effect_name
export(int) var param1 = 0
export(bool) var stackable = false
export(bool) var indestructible = false

var inventory_slot

func use():
	if use_function.empty():
		RPG.broadcast(owner.get_display_name() + " cannot be used", RPG.COLOR_DARK_GREY)
		return
	if has_method(use_function):
		call(use_function)

func pickup():
	var result = RPG.inventory.add_to_inventory(owner)
	return result

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
		return
	RPG.player.fighter.heal_damage(owner.get_display_name(), amount)
	emit_signal('used', "OK")

func damage_nearest():
	var amount = self.param1
	var target = RPG.map.get_nearest_visible_actor()
	if not target:
		emit_signal('used', "No targets in sight")
		return
	target.fighter.take_damage(self.effect_name, amount)
	var fx_tex = preload('res://graphics/fx/bolt_electricity.png')
	RPG.map.spawn_fx(fx_tex, target.get_map_pos())
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

func blast_cell():
	var amount = param1
	var target_cell = null
	# instruct the player to choose a target or cancel
	RPG.broadcast("Use your mouse to target a visible space.  LMB to select a target, RMB to cancel")
	# yield for map clicking feedback
	var callback = yield(RPG.game, 'map_clicked')
	
	# callback==null = RMB to cancel
	if callback == null:
		emit_signal('used', "action cancelled")
		return
	if not callback in RPG.map.fov_cells:
		emit_signal('used', "can't cast there!")
		return
	target_cell = callback
	
	# list of actors in blast area
	var actors = []
	
	var rect = []
	for x in range(-1,2):
		for y in range(-1,2):
			var cell = Vector2(x,y) + target_cell
			if not RPG.map.is_wall(cell):
				rect.append(cell)
				var fx_tex = preload('res://graphics/fx/bolt_fire.png')
				RPG.map.spawn_fx(fx_tex, cell)
	
	for node in get_tree().get_nodes_in_group('actors'):
		if node.get_map_pos() in rect:
			actors.append(node)
	for obj in actors:
		obj.fighter.take_damage(effect_name, amount)
	emit_signal('used', "OK")
