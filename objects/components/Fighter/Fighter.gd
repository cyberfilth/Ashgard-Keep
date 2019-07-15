extends Node

signal hp_changed(current,full)
signal xp_changed(what)
signal character_level_changed(what)
signal attack_changed(what)
signal defence_changed(what)
signal race_changed(what)
signal archetype_changed(what)
onready var owner = get_parent()

export(bool) var bleeds = true
export(String, "red", "green") var blood_colour
export(String, "Human", "Dwarf", "Elf", "animal") var race = "animal" setget _set_race
export(String, "Warrior", "Wizard", "Rogue") var archetype = "Warrior" setget _set_archetype
export(int) var character_level = 1 setget _set_character_level
export(int) var attack = 1 setget _set_attack
export(int) var defence = 1 setget _set_defence
export(int) var max_hp = 5 setget _set_max_hp

var killer = "No Juan" # Name of the enemy that kills the player
var xp = 0 setget _set_xp
var hp = 5 setget _set_hp

var status_effects = {}
var weapon_equipped = false
var armour_equipped = false
var weapon_dice = 0
var weapon_adds = 0
var armour_protection = 0
var hpbar

func restore(data):
	for key in data:
		if self.get(key)!=null:
			self.set(key, data[key])

func save():
	var data = {}
	data.bleeds = self.bleeds
	data.blood_colour = self.blood_colour
	data.race = self.race
	data.archetype = self.archetype
	data.character_level = self.character_level
	data.attack = self.attack
	data.defence = self.defence
	data.max_hp = self.max_hp
	data.hp = self.hp
	data.xp = self.xp
	data.status_effects = self.status_effects
	data.weapon_equipped = self.weapon_equipped
	return data

func has_status_effect(name):
	return name in self.status_effects

func process_status_effects():
	for key in self.status_effects:
		self.status_effects[key] -= 1
		if self.status_effects[key] <= 0:
			self.status_effects.erase(key)
			get_node('/root/Game/frame/right/StatusMessage').set_text("")

func apply_status_effect(name, time):
	if has_status_effect(name):
		if time > self.status_effects[name]:
			self.status_effects[name] = time
	else:
		self.status_effects[name] = time

func fill_hp():
	self.hp = self.max_hp

func is_hp_full():
	return self.hp >= self.max_hp

func _set_attack(what):
	attack = what
	emit_signal('attack_changed', attack)

func _set_defence(what):
	defence = what
	emit_signal('defence_changed', defence)

func fight(who):
	killer = who
	if owner.fighter.hp < 1:
		return
	else:
		if who.get_display_name() == owner.get_display_name():
			return
	# Weapon Modifier
		var max_roll = self.weapon_dice * 6
		var weapon_modifier = GameData.roll(self.weapon_dice, max_roll)
		var attack_roll = GameData.roll(0, self.attack)+weapon_modifier+self.weapon_adds
	# Defence Modifier
		var defence_roll = who.fighter.defence + who.fighter.armour_protection
		var damage_amount = attack_roll - defence_roll
		if damage_amount > 0:
			who.fighter.take_damage(owner.get_display_name(), damage_amount)
		elif damage_amount <= 0:
			broadcast_miss(who.get_display_name(), owner.get_display_name())
		else:
			return

func heal_damage(from,amount):
	var heal_amount = GameData.roll(2, amount) # Heals by a random amount
	if owner == GameData.player:
		broadcast_damage_healed(from, heal_amount)
	self.hp += heal_amount

func heal_non_random(from, amount):
	if owner == GameData.player:
		broadcast_damage_healed(from, amount)
		self.hp += amount

func take_damage(from="An Unknown Force", amount=0):
	broadcast_damage_taken(from,amount)
	killer = from
	self.hp -= amount

func broadcast_damage_healed(from="An Unknown Force", amount=0):
	var m = str(amount)
	var color = GameData.COLOR_GREEN
	GameData.broadcast(from+ " restores " +m+ " HP!", color)

func broadcast_damage_taken(from, amount):
	var m = str(amount)
	var color = GameData.COLOR_TEAL
	if owner == GameData.player:
		color = GameData.COLOR_RED
	if from == "Rat":
		GameData.broadcast(from+ " bites " +owner.get_display_name()+ " for " +m+ " damage",color)
	elif from == "Diseased Zombie" || from == "Scorpion":
		GameData.broadcast(from+ " claws " +owner.get_display_name()+ " for " +m+ " damage",color)
		# random chance of being poisoned by the zombie
		if owner == GameData.player:
			var chance_of_poison = randi()%3
			if chance_of_poison == 1:
				poisoned()
	elif from == "Poison":
		GameData.broadcast(from+ " blights " +owner.get_display_name()+ " and removes " +m+ " HP",GameData.COLOR_POISON_GREEN)
	elif from == "Fire":
		GameData.broadcast(from+ " burns " +owner.get_display_name()+ " for " +m+ " damage",color)
	elif from == "Lightning Strike":
		GameData.broadcast(from+ " zaps " +owner.get_display_name()+ " for " +m+ " damage",color)
	else:
		GameData.broadcast(from+ " attacks " +owner.get_display_name()+ " for " +m+ " damage",color)

func broadcast_miss(target, from):
	if self.hp <= 0:
		return # Stop a 'misses' message appearing after NPC is dead
	else:
		GameData.broadcast(from + " attacks " + target + " but misses ")

func die():
	if owner == GameData.player:
		game_over(killer)
	# Release cloud of gas if poison zombie killed
	var corpse = get_parent().name
	if corpse == "Diseased zombie":
		var gas_cloud = load("res://objects/monsters/undead/poison_cloud.tscn")
		var scene_instance = gas_cloud.instance()
		scene_instance.set_name("gas_cloud")
		GameData.map.add_child(scene_instance)
		scene_instance.set_pos(GameData.map.map_to_world(owner.get_map_pos()))
	# leave bloodstain
	if !owner.has_node("Inventory") && self.bleeds:
		bleed(blood_colour)
	# Get XP if you are the killer
	if killer == (GameData.player.get_display_name()) || killer == "Fire" || killer == "Lightning Strike":
		var xp_earned = self.attack
		GameData.player.fighter.xp += xp_earned
		GameData.broadcast("You gain "+ str(xp_earned) + " XP")
	# check if enemy drops any items
	if owner.has_node("Inventory"):
		var item = owner.get_node("Inventory").drop_item()
		print(item)
		var dropped = load(item)
		var dropped_item = dropped.instance()
		GameData.map.add_child(dropped_item)
		dropped_item.set_pos(GameData.map.map_to_world(owner.get_map_pos()))
		GameData.broadcast("The "+corpse+" drops an item")
	# remove the enemy from the screen
	owner.kill()

func game_over(killer):
	# Show the death screen
	GameData.killer = killer
	get_tree().change_scene('res://scenes/GameOver/RIPScreen.tscn')

func bleed(blood_colour):
	var blood = load('res://graphics/fx/blood_'+blood_colour+str(randi()%5)+'.png')
	var sprite = Sprite.new()
	sprite.set_centered(false)
	sprite.set_texture(blood)
	GameData.map.add_child(sprite)
	sprite.set_pos(GameData.map.map_to_world(owner.get_map_pos()))

func _ready():
	owner.fighter = self
	self.race = self.race
	self.archetype = self.archetype
	self.xp = self.xp
	self.character_level = self.character_level
	owner.add_to_group('actors')
	if owner != GameData.player:
		hpbar = preload('res://objects/components/Object/HPBar.tscn').instance()
		owner.call_deferred('add_child', hpbar)
		connect("hp_changed", self, "_on_hp_changed")

func _set_race(what):
	race = what
	emit_signal('race_changed', race)

func _set_archetype(what):
	archetype = what
	emit_signal('archetype_changed', archetype)

func _set_xp(what):
	xp = what
	emit_signal('xp_changed', xp)

func _set_character_level(what):
	character_level = what
	emit_signal('character_level_changed', character_level)

func _set_hp(what):
	hp = clamp(what, 0, self.max_hp)
	emit_signal('hp_changed', hp, self.max_hp)
	if hp <= 0:
		GameData.broadcast(owner.get_display_name()+ " is slain!", GameData.COLOR_TEAL)
		die()

func _set_max_hp(what):
	max_hp = what
	emit_signal('hp_changed', self.hp, self.max_hp)

func _on_hp_changed(current,full):
	hpbar.set_hidden(current >= full)
	hpbar.set_max(full)
	hpbar.set_value(current)

func poisoned():
	GameData.player.get_node('Glyph').add_color_override("default_color", Color(0,1,0,1))
	GameData.broadcast(owner.get_display_name() + " is poisoned", GameData.COLOR_POISON_GREEN)
	get_node('/root/Game/frame/right/StatusMessage').set_text("Poisoned")
	apply_status_effect('poisoned', 4)
