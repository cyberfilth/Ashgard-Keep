extends Node



signal hp_changed(current,full)

onready var owner = get_parent()

export(bool) var bleeds = true

export(int) var power = 1
export(int) var defense = 1

export(int) var max_hp = 5 setget _set_max_hp
var hp = 5 setget _set_hp

var status_effects = {}

var hpbar

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

func fight(who):
	if who.fighter:
		who.fighter.take_damage(owner.get_display_name(), self.power)

func heal_damage(from,amount):
	if owner == RPG.player:
		broadcast_damage_healed(from,amount)
	self.hp += amount

func take_damage(from="An Unknown Force", amount=0):
	broadcast_damage_taken(from,amount)
	self.hp -= amount

func broadcast_damage_healed(from="An Unknown Force", amount=0):
	var m = str(amount)
	var color = RPG.COLOR_GREEN
	RPG.broadcast(from+ " restores " +m+ " HP!", color)

func broadcast_damage_taken(from, amount):
	var m = str(amount)
	var color = RPG.COLOR_DARK_GREY
	if owner == RPG.player:
		color = RPG.COLOR_RED
	RPG.broadcast(from+ " hits " +owner.get_display_name()+ " for " +m+ " HP",color)

func die():
	if self.bleeds:
		bleed()
	owner.kill()

func bleed():
	var blood = load('res://graphics/misc/blood_red'+str(randi()%5)+'.png')
	var sprite = Sprite.new()
	sprite.set_centered(false)
	sprite.set_texture(blood)
	RPG.map.add_child(sprite)
	sprite.set_pos(RPG.map.map_to_world(owner.get_map_pos()))

func _ready():
	owner.fighter = self
	owner.add_to_group('actors')
	hpbar = preload('res://objects/components/Object/HPBar.tscn').instance()
	owner.call_deferred('add_child', hpbar)
	connect("hp_changed", self, "_on_hp_changed")



func _set_hp(what):
	hp = clamp(what, 0, self.max_hp)
	emit_signal('hp_changed', hp, self.max_hp)
	if hp <= 0:
		RPG.broadcast(owner.get_display_name()+ " is slain!", RPG.COLOR_DARK_GREEN)
		die()


func _set_max_hp(what):
	max_hp = what
	emit_signal('hp_changed', self.hp, self.max_hp)

func _on_hp_changed(current,full):
	hpbar.set_hidden(current >= full)
	hpbar.set_max(full)
	hpbar.set_value(current)


