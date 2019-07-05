extends Node

signal used(result)
signal landed(pos)

onready var owner = get_parent()

export(String,\
	'heal_player', 'damage_nearest',\
	'confuse_target', 'blast_cell',\
	'weapon', 'armour','torch') var use_function = ''

export(String, MULTILINE) var effect_name
export(int) var param1 = 0

export(bool) var stackable = false
export(bool) var indestructible = false

export(int,0,8) var throw_range = 0
export(int) var throw_damage = 0

export(bool) var equipped = false

var inventory_slot

var throw_path = [] setget _set_throw_path


func save():
	var data = {}
	data.use_function = self.use_function
	data.effect_name = self.effect_name
	data.param1 = self.param1
	data.stackable = self.stackable
	data.indestructible = self.indestructible
	data.throw_range = self.throw_range
	data.throw_damage = self.throw_damage
	data.equipped = self.equipped
	return data

func restore(data):
	for key in data:
		if get(key)!=null:
			set(key, data[key])
	self.throw_path = []


func use():
	if use_function.empty():
		GameData.broadcast(owner.get_display_name() + " cannot be used", GameData.COLOR_TEAL)
		return
	if has_method(use_function):
		call(use_function)


func pickup():
	var result = GameData.inventory.add_to_inventory(owner)
	return result

func drop():
	assert inventory_slot != null
	GameData.inventory.check_if_can_remove_from_inventory(inventory_slot,owner)

func throw():
	if self.throw_range <= 0:
		GameData.broadcast("You cannot throw that!")
		return
	else:
		GameData.broadcast("Which direction? Click the map to confirm, RMB to cancel")
	var cell = yield(GameData.game, 'map_clicked')
	
	if cell == null:
		GameData.broadcast("action cancelled")
		return
	else:
		GameData.broadcast("You throw " + owner.get_display_name())
		drop()
		
		var path = FOVGen.get_line(GameData.player.get_map_pos(), cell)
		if not path.empty():
			var tpath = []
			for cell in path:
				var actor = GameData.map.get_actor_in_cell(cell)
				if actor and actor != GameData.player:
					tpath.append(cell)
					break
				elif GameData.map.is_wall(cell):
					break
				else:
					tpath.append(cell)
			
			if tpath.size() > self.throw_range+1:
				tpath.resize(self.throw_range+1)
			self.throw_path = tpath
			var done = yield(self, 'landed')
			
			var target_cell = owner.get_map_pos()
			var target = GameData.map.get_actor_in_cell(target_cell)
			if target and target != GameData.player:
				if self.throw_damage > 0:
					target.fighter.take_damage(owner.get_display_name(), self.throw_damage)
		GameData.player.emit_signal('object_acted')

func _ready():
	owner.item = self

# USE FUNCTIONS
func heal_player():
	var amount = self.param1
	if GameData.player.fighter.is_hp_full():
		emit_signal('used', "You're already at full health")
		return
	GameData.player.fighter.heal_damage(owner.get_display_name(), amount)
# Timer added to avoid glitch where health
# potions were not being remove from inventory
	var t = Timer.new()
	t.set_wait_time(0.1)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	#####	
	emit_signal('used', "OK")

func damage_nearest():
	var amount = self.param1
	var target = GameData.map.get_nearest_visible_actor()
	if not target:
		emit_signal('used', "No targets in sight")
		return
	target.fighter.take_damage(self.effect_name, amount)
	GameData.map.spawn_lightningbolt_fx(target.get_pos())
	GameData.player.get_node("Camera").shake(0.3, 10)
	emit_signal('used', "OK")

func confuse_target():
	var target = null
	# instruct the player to choose a target or cancel
	GameData.broadcast("Select target with the mouse. Left-click to confirm, Right-click to cancel")
	# yield for map clicking feedback
	var callback = yield(GameData.game, 'map_clicked')
	
	# callback==null = RMB to cancel
	if callback==null:
		emit_signal('used', "action cancelled")
		return
	# cell clicked
	else:
		# assign potential target
		target = GameData.map.get_actor_in_cell(callback)
	# if no actor in cell
	if not target:
		emit_signal('used', "no target there")
		return
	# if clicking yourself
	elif target == GameData.player:
		emit_signal('used', "you don't want to confuse yourself!")
		return
	
	# found valid target
	GameData.broadcast(target.get_display_name() + " looks very confused!", GameData.COLOR_BLUE)
	target.fighter.apply_status_effect('confused',param1)
	emit_signal('used', "OK")

func weapon():
	var weapon = get_node('../Weapon')
	if equipped == true:
		unequip_weapon(weapon)
	elif GameData.player.fighter.weapon_equipped == true:
		GameData.broadcast('Unequip your current weapon before selecting a new one')
		return
	else:
		equip_weapon(weapon)

func unequip_weapon(weapon):
	var weapon_name = owner.get_display_name()
	inventory_slot.show_unequipped_weapon()
	## Update GUI ##
	var equipped_weapon = get_node('/root/Game/frame/right/Activity/box/weaponName')
	var weapon_description = get_node('/root/Game/frame/right/Activity/box/weaponDescription')
	equipped_weapon.set_text("No weapon equipped")
	weapon_description.set_text(" ")
	## Update weapon stats ##
	var dice = weapon.dice
	var adds = weapon.adds
	weapon.unequip(weapon_name, dice, adds)

func equip_weapon(weapon):
	var weapon_name = owner.get_display_name()
	## Update GUI ##
	inventory_slot.show_equipped_weapon()
	var equipped_weapon = get_node('/root/Game/frame/right/Activity/box/weaponName')
	var weapon_description = get_node('/root/Game/frame/right/Activity/box/weaponDescription')
	equipped_weapon.set_text(weapon_name + " equipped")
	weapon_description.set_text(weapon.description)
	## Update weapon stats ##
	var dice = weapon.dice
	var adds = weapon.adds
	weapon.equip(weapon_name, dice, adds)

func armour():
	var armour = get_node('../Armour')
	if equipped == true:
		unequip_armour(armour)
	elif GameData.player.fighter.armour_equipped == true:
		GameData.broadcast('Remove your current armour before selecting a new one')
		return
	else:
		equip_armour(armour)

func unequip_armour(armour):
	var armour_name = owner.get_display_name()
	inventory_slot.show_unequipped_armour()
	## Update GUI ##
	var equipped_armour = get_node('/root/Game/frame/right/Activity/box/armourName')
	var armour_description = get_node('/root/Game/frame/right/Activity/box/armourDescription')
	equipped_armour.set_text("No armour worn")
	armour_description.set_text(" ")
	## Update defence stats ##
	var armour_protection = armour.armour_protection
	armour.unequip(armour_name, armour_protection)

func equip_armour(armour):
	var armour_name = owner.get_display_name()
	## Update GUI ##
	inventory_slot.show_equipped_armour()
	var equipped_armour = get_node('/root/Game/frame/right/Activity/box/armourName')
	var armour_description = get_node('/root/Game/frame/right/Activity/box/armourDescription')
	equipped_armour.set_text(armour_name + " worn")
	armour_description.set_text(armour.description)
	## Update defence stats ##
	var armour_protection = armour.armour_protection
	armour.equip(armour_name, armour_protection)

func blast_cell():
	var amount = param1
	var target_cell = null
	# instruct the player to choose a target or cancel
	GameData.broadcast("Select target with the mouse. Left-click to confirm, Right-click to cancel")
	# yield for map clicking feedback
	var callback = yield(GameData.game, 'map_clicked')
	
	# callback==null = RMB to cancel
	if callback == null:
		emit_signal('used', "action cancelled")
		return
	if not callback in GameData.map.fov_cells:
		emit_signal('used', "can't cast there!")
		return
	target_cell = callback
	# list of actors in blast area
	var actors = []
	var rect = []
	for x in range(-1,2):
		for y in range(-1,2):
			var cell = Vector2(x,y) + target_cell
			if not GameData.map.is_wall(cell):
				rect.append(cell)
				GameData.map.spawn_inferno_fx(cell)
				GameData.player.get_node("Camera").shake(0.4, 16)
	for node in get_tree().get_nodes_in_group('actors'):
		if node.get_map_pos() in rect:
			actors.append(node)
	for obj in actors:
		obj.fighter.take_damage(effect_name, amount)
	emit_signal('used', "OK")

func _process(delta):
	if throw_path.empty():
		emit_signal('landed', owner.get_map_pos())
		set_process(false)
	else:
		var i = min(throw_path.size()-1, 1)
		owner.set_map_pos(throw_path[i], true)
		throw_path.remove(0)

func _set_throw_path(what):
	throw_path = what
	if !throw_path.empty():
		set_process(true)
