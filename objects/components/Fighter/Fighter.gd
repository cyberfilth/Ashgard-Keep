extends Node

signal hp_changed(current,full)
signal attack_changed(what)
signal defence_changed(what)
signal race_changed(what)
onready var owner = get_parent()

export(bool) var bleeds = true
export(String, "red", "green") var blood_colour
export(String, "Human", "Dwarf", "Elf", "animal") var race = "animal" setget _set_race

export(int) var attack = 1 setget _set_attack
export(int) var defence = 1 setget _set_defence

export(int) var max_hp = 5 setget _set_max_hp
var hp = 5 setget _set_hp

var status_effects = {}

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
	data.attack = self.attack
	data.defence = self.defence
	data.max_hp = self.max_hp
	data.hp = self.hp
	data.status_effects = self.status_effects
	return data

func has_status_effect(name):
	return name in self.status_effects

func process_status_effects():
	for key in self.status_effects:
		self.status_effects[key] -= 1
		if self.status_effects[key] <= 0:
			self.status_effects.erase(key)

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
	# Damage = 0 to ATTACK amount - DEFENCE
	var damage_amount = GameData.roll(0, self.attack) - who.fighter.defence
	if damage_amount > 0:
		who.fighter.take_damage(owner.get_display_name(), damage_amount)
	elif damage_amount <= 0:
		broadcast_miss(owner.get_display_name())
	else:
		return

func heal_damage(from,amount):
	var heal_amount = GameData.roll(2, amount) # Heals by a random amount
	if owner == GameData.player:
		broadcast_damage_healed(from, heal_amount)
	self.hp += heal_amount

func take_damage(from="An Unknown Force", amount=0):
	broadcast_damage_taken(from,amount)
	self.hp -= amount

func broadcast_damage_healed(from="An Unknown Force", amount=0):
	var m = str(amount)
	var color = GameData.COLOR_GREEN
	GameData.broadcast(from+ " restores " +m+ " HP!", color)

func broadcast_damage_taken(from, amount):
	var m = str(amount)
	var color = GameData.COLOR_DARK_GREY
	if owner == GameData.player:
		color = GameData.COLOR_RED
	if from == "Rat":
		GameData.broadcast(from+ " bites " +owner.get_display_name()+ " for " +m+ " damage",color)
	else:
		GameData.broadcast(from+ " attacks " +owner.get_display_name()+ " for " +m+ " damage",color)

func broadcast_miss(from):
	if self.hp <= 0:
		return # Stop a 'misses' message appearing after NPC is dead
	else:
		GameData.broadcast(from + " misses ")

func die():
	if self.bleeds:
		bleed(blood_colour)
	owner.kill()

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
	owner.add_to_group('actors')
	hpbar = preload('res://objects/components/Object/HPBar.tscn').instance()
	owner.call_deferred('add_child', hpbar)
	connect("hp_changed", self, "_on_hp_changed")

func _set_race(what):
	race = what
	emit_signal('race_changed', race)

func _set_hp(what):
	hp = clamp(what, 0, self.max_hp)
	emit_signal('hp_changed', hp, self.max_hp)
	if hp <= 0:
		GameData.broadcast(owner.get_display_name()+ " is slain!", GameData.COLOR_DARK_GREEN)
		die()


func _set_max_hp(what):
	max_hp = what
	emit_signal('hp_changed', self.hp, self.max_hp)

func _on_hp_changed(current,full):
	hpbar.set_hidden(current >= full)
	hpbar.set_max(full)
	hpbar.set_value(current)


