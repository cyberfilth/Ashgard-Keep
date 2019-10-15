extends Node

signal hp_changed(current,full)
signal xp_changed(what)
signal character_level_changed(what)
signal attack_changed(what)
signal defence_changed(what)
signal race_changed(what)
onready var object_owner = get_parent()

export(bool) var bleeds = true
export(String, "red", "green", "scarlet", "jade") var blood_colour
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
	if object_owner.fighter.hp < 1:
		return
	# Step through a portal
	if object_owner.get_display_name() == "A Portal" && who == GameData.player:
		object_owner.get_node('AI').enter_portal()
	if  who.get_display_name() == "A Portal" && object_owner == GameData.player:
		who.get_node('AI').enter_portal()
	# Matango changes enemies to mushroom people.... no, really.
	# .... you should totally watch the film Matango!
	if object_owner.get_display_name() == "Emperor Fungus"\
	&& who != GameData.player\
	&& who.get_display_name() != "Mushroom Person":
		var spore_cloud = load("res://graphics/particles/spore_cloud.tscn")
		var scene_instance = spore_cloud.instance()
		scene_instance.set_name("spore_cloud")
		GameData.map.add_child(scene_instance)
		scene_instance.set_position(GameData.map.map_to_world(object_owner.get_map_position()))
		GameData.map.transform_to_mushroom(who.get_display_name(), GameData.map.map_to_world(object_owner.get_map_position()))
		who.kill()
	else: # Stops similar NPC's killing each other
		if who.get_display_name() == object_owner.get_display_name():
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
			who.fighter.take_damage(object_owner.get_display_name(), damage_amount)
		elif damage_amount <= 0:
			broadcast_miss(who.get_display_name(), object_owner.get_display_name())
		else:
			return

func heal_damage(from,amount):
	var heal_amount = GameData.roll((amount/2), amount) # Heals by a random amount
	if object_owner == GameData.player:
		broadcast_damage_healed(from, heal_amount)
	self.hp += heal_amount

func heal_non_random(from, amount):
	if object_owner == GameData.player:
		broadcast_damage_healed(from, amount)
		self.hp += amount

func take_damage(from="An Unknown Force", amount=0):
	if object_owner.get_display_name() == "A Portal":
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
	if object_owner.get_display_name() == "Demonic Puppy":
		if object_owner.fighter.hp > 1 && object_owner.fighter.hp <= 9:
			object_owner.get_node("AI").transform_to_hound()
			GameData.map.spawn_hell_hound(GameData.map.map_to_world(object_owner.get_map_position()))
			object_owner.kill()

func broadcast_damage_healed(from="An Unknown Force", amount=0):
	var m = str(amount)
	var color = GameData.COLOUR_GREEN
	GameData.broadcast(from+ " restores " +m+ " HP!", color)

func broadcast_damage_taken(from, amount):
	# Suppress messages if combat takes place off screen
	if !object_owner.is_visible() && object_owner.get_display_name() != "Shadow":
		return
	# Broadcast damage in message log
	var m = str(amount)
	var color = GameData.COLOUR_TEAL
	if object_owner == GameData.player:
		color = GameData.COLOUR_RED
	if from == "Rat" || from == "Ghoul Rat" || from == "Hell Puppy" || from == "Hell Hound":
		GameData.broadcast(from+ " bites " +object_owner.get_display_name()+ " for " +m+ " damage",color)
	elif from == "Diseased Zombie":
		GameData.broadcast(from+ " claws " +object_owner.get_display_name()+ " for " +m+ " damage",color)
		# random chance of being poisoned by the zombie
		if object_owner == GameData.player:
			var chance_of_poison = randi()%3
			if chance_of_poison == 1:
				poisoned(6)
	elif from == "Blue Fungus":
		GameData.broadcast(from+ " confuses " +object_owner.get_display_name()+ " and inflicts " +m+ " damage",color)
		if object_owner == GameData.player:
			confused(3)
	elif from == "Green Fungus":
		GameData.broadcast(from+ " poisons " +object_owner.get_display_name()+ " and inflicts " +m+ " damage",color)
		if object_owner == GameData.player:
			poisoned(3)
	elif from.ends_with("Rock Troll"):
		GameData.broadcast(from+ " bashes "+object_owner.get_display_name()+ " for " +m+ " damage",color)
		if object_owner == GameData.player && GameData.weapon_type == "sharp":
			GameData.weapon_in_use.get_node('Weapon').break_weapon(GameData.weapon_name, GameData.player.fighter.weapon_dice, GameData.player.fighter.weapon_adds)
	elif from == "Giant Scorpion":
		GameData.broadcast(from+ " jabs "+object_owner.get_display_name()+ " for " +m+ " damage",color)
		# random chance of being paralysed by scorpion
		if object_owner == GameData.player:
			var chance_of_paralysis = randi()%3
			if chance_of_paralysis == 1:
				paralysed()
	elif from == "Poison":
		GameData.broadcast(from+ " blights " +object_owner.get_display_name()+ " and removes " +m+ " HP",GameData.COLOUR_POISON_GREEN)
	elif from == "Fire":
		GameData.broadcast(from+ " burns " +object_owner.get_display_name()+ " for " +m+ " damage",color)
		if object_owner.get_display_name() == "Patchwork Golem":
			object_owner.get_node("AI").run_from_fire()
	elif from == "Lightning Strike":
		GameData.broadcast(from+ " zaps " +object_owner.get_display_name()+ " for " +m+ " damage",color)
	else:
		GameData.broadcast(from+ " attacks " +object_owner.get_display_name()+ " for " +m+ " damage",color)

func broadcast_miss(target, from):
	if target == "A Portal": # Stops messages about NPC's walking into portals
		return
	if self.hp <= 0:
		return # Stop a 'misses' message appearing after NPC is dead
	else:
		GameData.broadcast(from + " attacks " + target + " but misses ")

func die():
	if object_owner == GameData.player:
		game_over(killer)
	var corpse = get_parent().name
	# Release cloud of gas if poison zombie killed
	if corpse == "Diseased zombie":
		var gas_cloud = load("res://objects/monsters/undead/poison_cloud.tscn")
		var scene_instance = gas_cloud.instance()
		scene_instance.set_name("gas_cloud")
		GameData.map.add_child(scene_instance)
		scene_instance.set_position(GameData.map.map_to_world(object_owner.get_map_position()))
	# Release fairy dust if fairy killed
	if corpse == "Fairy Assassin":
		var fairy_dust = load("res://graphics/particles/fairy_dust.tscn")
		var scene_instance = fairy_dust.instance()
		scene_instance.set_name("fairy_dust")
		GameData.map.add_child(scene_instance)
		scene_instance.set_position(GameData.map.map_to_world(object_owner.get_map_position()))
	# Release pixie dust if pixie killed
	if corpse == "Pixie Beserker":
		var pixie_dust = load("res://graphics/particles/pixie_dust.tscn")
		var scene_instance = pixie_dust.instance()
		scene_instance.set_name("pixie_dust")
		GameData.map.add_child(scene_instance)
		scene_instance.set_position(GameData.map.map_to_world(object_owner.get_map_position()))
	if corpse == "Pixie Warrior":
		var pixie_dust = load("res://graphics/particles/pixie_warrior_dust.tscn")
		var scene_instance = pixie_dust.instance()
		scene_instance.set_name("pixie_dust")
		GameData.map.add_child(scene_instance)
		scene_instance.set_position(GameData.map.map_to_world(object_owner.get_map_position()))
				# Release yellow cloud if fungus killed
	if corpse == "Yellow fungus":
		var spore_cloud = load("res://graphics/particles/spore_cloud.tscn")
		var scene_instance = spore_cloud.instance()
		scene_instance.set_name("spore_cloud")
		GameData.map.add_child(scene_instance)
		scene_instance.set_position(GameData.map.map_to_world(object_owner.get_map_position()))
		GameData.map.release_blue_spores(object_owner.get_map_position())
	if corpse == "Purple fungus":
		var spore_cloud = load("res://graphics/particles/spore_cloud.tscn")
		var scene_instance = spore_cloud.instance()
		scene_instance.set_name("spore_cloud")
		GameData.map.add_child(scene_instance)
		scene_instance.set_position(GameData.map.map_to_world(object_owner.get_map_position()))
		GameData.map.release_green_spores(object_owner.get_map_position())
		# leave bloodstain
	if self.bleeds:
			bleed(blood_colour)
	# Get XP if you are the killer
	if killer == (GameData.player.get_display_name()) || killer == "Fire" || killer == "Lightning Strike":
		var xp_earned = self.xp_reward
		GameData.player.fighter.xp += xp_earned
		GameData.broadcast("You gain "+ str(xp_earned) + " XP")
		# add to list of enemies killed
		GameData.death_list.append(object_owner.get_display_name())
	# check if enemy drops any items
	if object_owner.has_node("Inventory"):
		var item = object_owner.get_node("Inventory").drop_item()
		var dropped = load(item)
		var dropped_item = dropped.instance()
		GameData.map.add_child(dropped_item)
		dropped_item.set_position(GameData.map.map_to_world(object_owner.get_map_position()))
		dropped_item.z_index =GameData.LAYER_ITEM
		GameData.broadcast("The "+corpse+" drops an item")
		#bleed(blood_colour)
	# remove the enemy from the screen
	object_owner.kill()

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
	sprite.set_position(GameData.map.map_to_world(object_owner.get_map_position()))
	sprite.z_index = (GameData.LAYER_DECAL)

func _ready():
	object_owner.fighter = self
	self.race = self.race
	self.xp = self.xp
	object_owner.add_to_group('actors')
	if object_owner != GameData.player:
		hpbar = preload('res://objects/components/Object/HPBar.tscn').instance()
		object_owner.call_deferred('add_child', hpbar)
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
		GameData.broadcast(object_owner.get_display_name()+ " is slain!", GameData.COLOUR_TEAL)
		die()

func _set_max_hp(what):
	max_hp = what
	emit_signal('hp_changed', self.hp, self.max_hp)

func _on_hp_changed(current,full):
	hpbar.visible = !(current >= full)
	hpbar.set_max(full)
	hpbar.set_value(current)

func confused(num):
	get_node('/root/Game/frame/right/StatusMessage').set_text("Confused")
	apply_status_effect('confused', num)

func poisoned(num):
	GameData.player.get_node('Glyph').add_color_override("default_color", Color(0,1,0,1))
	GameData.broadcast(object_owner.get_display_name() + " is poisoned", GameData.COLOUR_POISON_GREEN)
	get_node('/root/Game/frame/right/StatusMessage').set_text("Poisoned")
	apply_status_effect('poisoned', num)

func paralysed():
	GameData.player.get_node('Glyph').add_color_override("default_color", Color(0.44, 0.5, 0.56, 1))
	GameData.broadcast(object_owner.get_display_name() + " is paralysed", GameData.COLOUR_SLATE_GREY)
	get_node('/root/Game/frame/right/StatusMessage').set_text("Paralysed")
	apply_status_effect('paralysed', 5)

func stuck(num):
	get_node('/root/Game/frame/right/StatusMessage').set_text("Stuck")
	apply_status_effect('stuck', num)

