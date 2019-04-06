extends Node

signal hp_changed(current,full)

onready var owner = get_parent()

export(bool) var bleeds = true

export(int) var power = 1
export(int) var defense = 1

export(int) var max_hp = 5 setget _set_max_hp
var hp = 5 setget _set_hp

var hpbar

func fill_hp():
	self.hp = self.max_hp

func fight(who):
	if who.fighter:
		who.fighter.take_damage(owner,self.power)

func take_damage(from,amount):
	broadcast_damage_taken(from,amount)
	self.hp -= amount

func broadcast_damage_taken(from, amount):
	var n = from.name
	var m = str(amount)
	var color = RPG.COLOR_DARK_GREY
	if owner == RPG.player:
		color = RPG.COLOR_RED
	RPG.broadcast(n+ " hits " +owner.name+ " for " +str(amount)+ " HP",color)

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
	hp = what
	emit_signal('hp_changed', hp, self.max_hp)
	if hp <= 0:
		RPG.broadcast(owner.name+ " is slain!", RPG.COLOR_DARK_GREEN)
		die()


func _set_max_hp(what):
	max_hp = what
	emit_signal('hp_changed', self.hp, self.max_hp)

func _on_hp_changed(current,full):
	hpbar.set_hidden(current >= full)
	hpbar.set_max(full)
	hpbar.set_value(current)