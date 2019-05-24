extends Node

signal used(result)
signal landed(pos)

onready var owner = get_parent()

export(int) var damage_adds = 0
export(bool) var stackable = false
export(bool) var indestructible = false
export(bool) var equipped = false
export(int,0,8) var throw_range = 0
export(int) var throw_damage = 0

var inventory_slot

var throw_path = [] setget _set_throw_path

func pickup():
	var result = GameData.inventory.add_to_inventory(owner)
	return result

func drop():
	assert inventory_slot != null
	GameData.inventory.remove_from_inventory(inventory_slot,owner)

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

func save():
	var data = {}
	data.damage_adds = self.damage_adds
	data.stackable = self.stackable
	data.equipped = self.equipped
	data.indestructible = self.indestructible
	data.throw_range = self.throw_range
	data.throw_damage = self.throw_damage
	return data

func restore(data):
	for key in data:
		if get(key)!=null:
			set(key, data[key])
	self.throw_path = []