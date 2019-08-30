extends Node

signal hp_changed(current,full)
signal xp_changed(what)
signal character_level_changed(what)
signal attack_changed(what)
signal defence_changed(what)
signal race_changed(what)
onready var owner = get_parent()

export(bool) var bleeds = true
export(String, "red", "green") var blood_colour
export(String, "Human", "Dwarf", "Elf", "animal") var race = "animal" setget _set_race
export(int) var character_level = 1 setget _set_character_level
export(int) var attack = 1 setget _set_attack
export(int) var defence = 1 setget _set_defence
export(int) var max_hp = 5 setget _set_max_hp
export(int) var xp_reward = 5

var killer = "No Juan" # Name of the enemy that kills the player
var xp = 0 setget _set_xp
var hp = 5 setget _set_hp

var status_effects = {}
var weapon_equipped = false
var armour_equipped = false
var weapon_dice = 0
var weapon_adds = 0
var weapon_modifier = "attack"
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
	data.character_level = self.character_level
	data.attack = self.attack
	data.defence = self.defence
	data.max_hp = self.max_hp
	data.hp = hp
	data.xp = self.xp
	data.status_effects = self.status_effects
	data.weapon_equipped = self.weapon_equipped
	data.armour_equipped = self.armour_equipped
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
	# Step through a portal
	if owner.get_display_name() == "A Portal" && who == GameData.player:
		owner.get_node('AI').enter_portal()
	if  who.get_display_name() == "A Portal" && owner == GameData.player:
		who.get_node('AI').enter_portal()
	else: # Stops similar NPC's killing each other
		if who.get_display_name() == owner.get_display_name():
			return
	# COMBAT
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
	var heal_amount = GameData.roll((amount/2), amount) # Heals by a random amount
	if owner == GameData.player:
		broadcast_damage_healed(from, heal_amount)
	self.hp += heal_amount

func heal_non_random(from, amount):
	if owner == GameData.player:
		broadcast_damage_healed(from, amount)
		self.hp += amount

func take_damage(from="An Unknown Force", amount=0):
	if owner.get_display_name() == "A Portal":
		return
	broadcast_damage_taken(from,amount)
	killer = from
	self.hp -= amount
	# Add weapon effects here
	if from == GameData.player.get_display_name() && amount > 0:
		if GameData.player.fighter.weapon_modifier == "hp_drain":
			# random chance of HP drain
			var chance_of_drain = randi()%3
			if chance_of_drain == 1:
				GameData.player.fighter.hp+=2
				GameData.broadcast("Your weapon drinks your opponents life force, restoring 2 HP", GameData.COLOUR_GREEN)
	# Add damage triggered effects here
	if owner.get_display_name() == "Demonic Puppy":
		if owner.fighter.hp > 1 && owner.fighter.hp <= 9:
			owner.get_node("AI").transform_to_hound()
			GameData.map.spawn_hell_hound(GameData.map.map_to_world(owner.get_map_pos()))
			owner.kill()

func broadcast_damage_healed(from="An Unknown Force", amount=0):
	var m = str(amount)
	var color = GameData.COLOUR_GREEN
	GameData.broadcast(from+ " restores " +m+ " HP!", color)

func broadcast_damage_taken(from, amount):
	var m = str(amount)
	var color = GameData.COLOUR_TEAL
	if owner == GameData.player:
		color = GameData.COLOUR_RED
	if from == "Rat" || from == "Ghoul Rat" || from == "Hell Puppy" || from == "Hell Hound":
		GameData.broadcast(from+ " bites " +owner.get_display_name()+ " for " +m+ " damage",color)
	elif from == "Diseased Zombie":
		GameData.broadcast(from+ " claws " +owner.get_display_name()+ " for " +m+ " damage",color)
		# random chance of being poisoned by the zombie
		if owner == GameData.player:
			var chance_of_poison = randi()%3
			if chance_of_poison == 1:
				poisoned(6)
	elif from == "Blue Fungus":
		GameData.broadcast(from+ " confuses " +owner.get_display_name()+ " and inflicts " +m+ " damage",color)
		if owner == GameData.player:
			confused(3)
	elif from == "Giant Scorpion":
		GameData.broadcast(from+ " jabs "+owner.get_display_name()+ " for " +m+ " damage",color)
		# random chance of being paralysed by scorpion
		if owner == GameData.player:
			var chance_of_paralysis = randi()%3
			if chance_of_paralysis == 1:
				paralysed()
	elif from == "Poison":
		GameData.broadcast(from+ " blights " +owner.get_display_name()+ " and removes " +m+ " HP",GameData.COLOUR_POISON_GREEN)
	elif from == "Fire":
		GameData.broadcast(from+ " burns " +owner.get_display_name()+ " for " +m+ " damage",color)
		if owner.get_display_name() == "Patchwork Golem":
			owner.get_node("AI").run_from_fire()
	elif from == "Lightning Strike":
		GameData.broadcast(from+ " zaps " +owner.get_display_name()+ " for " +m+ " damage",color)
	else:
		GameData.broadcast(from+ " attacks " +owner.get_display_name()+ " for " +m+ " damage",color)

func broadcast_miss(target, from):
	if target == "A Portal": # Stops messages about NPC's walking into portals
		return
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
	if corpse == "Yellow fungus":
		var spore_cloud = load("res://graphics/particles/spore_cloud.tscn")
		var scene_instance = spore_cloud.instance()
		scene_instance.set_name("spore_cloud")
		GameData.map.add_child(scene_instance)
		scene_instance.set_pos(GameData.map.map_to_world(owner.get_map_pos()))
		GameData.map.release_blue_spores(owner.get_map_pos())
		# leave bloodstain
	if !owner.has_node("Inventory") && self.bleeds:
		bleed(blood_colour)
	# Get XP if you are the killer
	if killer == (GameData.player.get_display_name()) || killer == "Fire" || killer == "Lightning Strike":
		var xp_earned = self.xp_reward
		GameData.player.fighter.xp += xp_earned
		GameData.broadcast("You gain "+ str(xp_earned) + " XP")
	# check if enemy drops any items
	if owner.has_node("Inventory"):
		var item = owner.get_node("Inventory").drop_item()
		var dropped = load(item)
		var dropped_item = dropped.instance()
		GameData.map.add_child(dropped_item)
		dropped_item.set_pos(GameData.map.map_to_world(owner.get_map_pos()))
		GameData.broadcast("The "+corpse+" drops an item")
		bleed(blood_colour)
	# remove the enemy from the screen
	owner.kill()

func game_over(killer):
	# Show the death screen
	GameData.killer = killer
	GameData.broadcast("You have died!")
	Transition.fade_to('res://scenes/GameOver/RIPScreen.tscn')
	get_tree().set_pause(true)

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
	self.xp = self.xp
	owner.add_to_group('actors')
	if owner != GameData.player:
		hpbar = preload('res://objects/components/Object/HPBar.tscn').instance()
		owner.call_deferred('add_child', hpbar)
		connect("hp_changed", self, "_on_hp_changed")

func _set_race(what):
	race = what
	emit_signal('race_changed', race)

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
		GameData.broadcast(owner.get_display_name()+ " is slain!", GameData.COLOUR_TEAL)
		die()

func _set_max_hp(what):
	max_hp = what
	emit_signal('hp_changed', self.hp, self.max_hp)

func _on_hp_changed(current,full):
	hpbar.set_hidden(current >= full)
	hpbar.set_max(full)
	hpbar.set_value(current)

func confused(num):
	get_node('/root/Game/frame/right/StatusMessage').set_text("Confused")
	apply_status_effect('confused', num)

func poisoned(num):
	GameData.player.get_node('Glyph').add_color_override("default_color", Color(0,1,0,1))
	GameData.broadcast(owner.get_display_name() + " is poisoned", GameData.COLOUR_POISON_GREEN)
	get_node('/root/Game/frame/right/StatusMessage').set_text("Poisoned")
	apply_status_effect('poisoned', num)

func paralysed():
	GameData.player.get_node('Glyph').add_color_override("default_color", Color(0.44, 0.5, 0.56, 1))
	GameData.broadcast(owner.get_display_name() + " is paralysed", GameData.COLOUR_SLATE_GREY)
	get_node('/root/Game/frame/right/StatusMessage').set_text("Paralysed")
	apply_status_effect('paralysed', 5)
