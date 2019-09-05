extends Node

signal landed(pos)

onready var owner = get_parent()

export(String,\
	'heal_player', 'damage_nearest',\
	'confuse_target', 'blast_cell',\
	'weapon', 'armour','torch','read',\
	'stealth', 'throw') var use_function = ''

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


func use(slot):
	if use_function.empty():
		GameData.broadcast(owner.get_display_name() + " cannot be used", GameData.COLOUR_TEAL)
		return
	if has_method(use_function):
		call(use_function, slot)

func pickup():
	var result = GameData.inventory.add_to_inventory(owner)
	return result

func drop():
	assert inventory_slot != null
	GameData.inventory.check_if_can_remove_from_inventory(inventory_slot,owner)

func throw(slot):
	if self.throw_range <= 0:
		GameData.broadcast("You cannot throw that!")
		return
	else:
		GameData.broadcast("Which direction? Click the map to confirm, RMB to cancel")
	# Place mouse pointer on game map
	get_viewport().warp_mouse(get_viewport().get_rect().size/2.0)
	# Restrict mouse pointer until object has been thrown or cancelled
	GameData.in_use = true
	var cell = yield(GameData.game, 'map_clicked')
	if cell == null:
		GameData.broadcast("action cancelled")
		GameData.in_use = false
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
		GameData.in_use = false

func npc_throw(npc, npc_pos):
		var cell = GameData.player.get_map_pos()
		GameData.broadcast(npc+ " throws " + owner.get_display_name())
		var path = FOVGen.get_line(owner.get_map_pos(), cell)
		if not path.empty():
			var tpath = []
			for cell in path:
				var actor = GameData.map.get_actor_in_cell(npc_pos)
				if actor && actor == GameData.player:
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
			if target:
				if self.throw_damage > 0:
					# chance of a miss
					var miss_chance = randi()%3
					if miss_chance == 1:
						GameData.broadcast(owner.get_display_name()+" misses you")
					else:
						target.fighter.take_damage(owner.get_display_name(), self.throw_damage)

func _ready():
	owner.item = self

# USE FUNCTIONS
func heal_player(slot):
	var amount = self.param1
	if GameData.player.fighter.is_hp_full():
		GameData.use_item = "You're already at full health"
		return
	GameData.player.fighter.heal_damage(owner.get_display_name(), amount)
	GameData.use_item = "OK"
	GameData.inventory.after_item_used(slot)

func stealth(slot):
	if GameData.player.fighter.has_status_effect('poisoned'):
		GameData.use_item = "You cannot drink this potion whilst poisoned!"
		return
	if GameData.player.fighter.has_status_effect('paralysed'):
		GameData.use_item = "You cannot drink this potion whilst paralysed!"
		return
	GameData.original_player_radius = GameData.player_radius
	GameData.player_radius = 1
	var stealth_time = self.param1
	GameData.broadcast("You are able to creep through the shadows unseen", GameData.COLOUR_GREEN)
	GameData.player.fighter.apply_status_effect('stealth', stealth_time)
	get_node('/root/Game/frame/right/StatusMessage').set_text("Stealthy")
	GameData.use_item = "OK"
	GameData.inventory.after_item_used(slot)

func damage_nearest(slot):
	var amount = self.param1
	var target = GameData.map.get_nearest_visible_actor()
	if not target:
		GameData.use_item = "No targets in sight"
		GameData.inventory.after_item_used(slot)
		return
	target.fighter.take_damage(self.effect_name, amount)
	GameData.map.spawn_lightningbolt_fx(target.get_pos())
	GameData.player.get_node("Camera").shake(0.3, 10)
	GameData.use_item = "OK"
	GameData.inventory.after_item_used(slot)

func confuse_target(slot):
	var target = null
	# instruct the player to choose a target or cancel
	GameData.broadcast("Select target with the mouse. Left-click to confirm, Right-click to cancel")
	# yield for map clicking feedback
	var callback = yield(GameData.game, 'map_clicked')
	# callback==null = RMB to cancel
	if callback==null:
		GameData.use_item = "action cancelled"
		GameData.inventory.after_item_used(slot)
		return
	# cell clicked
	else:
		# assign potential target
		target = GameData.map.get_actor_in_cell(callback)
	# if no actor in cell
	if not target:
		GameData.use_item = "no target there"
		GameData.inventory.after_item_used(slot)
		return
	# if clicking yourself
	elif target == GameData.player:
		GameData.use_item = "you don't want to confuse yourself!"
		GameData.inventory.after_item_used(slot)
		return
	# found valid target
	GameData.broadcast(target.get_display_name() + " looks very confused!", GameData.COLOUR_BLUE)
	target.fighter.apply_status_effect('confused', param1)
	GameData.use_item = "OK"
	GameData.inventory.after_item_used(slot)

func weapon(slot):
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
	GameData.use_item = "Equipped"

func armour(slot):
	var armour = get_node('../Armour')
	if equipped == true:
		unequip_armour(armour)
	elif GameData.player.fighter.armour_equipped == true:
		GameData.broadcast('Remove your current armour before selecting a new one')
		return
	else:
		equip_armour(armour)
		GameData.use_item = "Equipped"

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

func blast_cell(slot):
	# Place mouse pointer on game map
	get_viewport().warp_mouse(get_viewport().get_rect().size/2.0)
	# Restrict mouse pointer until spell has been cast or cancelled
	GameData.in_use = true
	var amount = param1
	var target_cell = null
	# instruct the player to choose a target or cancel
	GameData.broadcast("Select target with the mouse. Click the map to confirm, RMB to cancel")
	# yield for map clicking feedback
	var callback = yield(GameData.game, 'map_clicked')
	# callback==null = RMB to cancel
	if callback == null:
		GameData.use_item = "action cancelled"
		GameData.inventory.after_item_used(slot)
		return
	elif !callback in GameData.map.fov_cells:
		GameData.use_item = "can't cast there!"
		GameData.inventory.after_item_used(slot)
		return
	target_cell = callback
	# list of actors in blast area
	var actors = []
	var rect = []
	for x in range(-1,2):
		for y in range(-1,2):
			var cell = Vector2(x,y) + target_cell
			if !GameData.map.is_wall(cell):
				rect.append(cell)
				GameData.map.spawn_inferno_fx(cell)
				GameData.player.get_node("Camera").shake(0.4, 16)
	for node in get_tree().get_nodes_in_group('actors'):
		if node.get_map_pos() in rect:
			actors.append(node)
	for obj in actors:
		obj.fighter.take_damage(effect_name, amount)
	GameData.use_item = "OK"
	GameData.inventory.after_item_used(slot)

func read(slot):
	get_node("../Lore").read_book()
	GameData.use_item = "OK"
	GameData.inventory.after_item_used(slot)

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