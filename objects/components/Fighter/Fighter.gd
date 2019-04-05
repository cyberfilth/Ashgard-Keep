extends Node

onready var owner = get_parent()

export(bool) var bleeds = true
export(int) var power = 1
export(int) var defense = 1
export(int) var max_hp = 5
var hp = 5 setget _set_hp

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
	RPG.broadcast(owner.name + " is hit by " +n+ " for " +m+ " points of damage")

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


func _set_hp(what):
	hp = what
	if hp <= 0:
		RPG.broadcast(owner.name+ " is slain!")
		die()
	else:
		RPG.broadcast(owner.name+ " has " +str(hp)+ " HP left")